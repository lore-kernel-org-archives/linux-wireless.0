Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45852 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab2IWSjm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2012 14:39:42 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: m@bues.ch
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC] b43-fwcutter: Add support for generating a fw for brcmsmac
Date: Sun, 23 Sep 2012 20:39:22 +0200
Message-Id: <1348425562-30730-1-git-send-email-hauke@hauke-m.de> (sfid-20120923_204027_864114_0106817B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The normal firmware for brcmsmac is available in the linux-firmware git
repository, but this firmware does not work on a bcm4716 devices with a
ieee80211 core rev 16. When using a firmware extracted from the
proprietary Broadcom driver the device works with brcmsmac.

I tested a firmware version 666.2 extracted from the proprietary driver
with brcmsmac on a BCM4716 and a BCM43224 and haven't seen any
problems. The interface between the firmware and the driver changed
some times, brcmsmac only support firmware version 598 and newer.

For some entries in the firmware used by brcmsmac, fwcutter has to be
more extended, so we are adding dummy entires for them in
brcmsmac_add_dummy_entries(). Currently these entries are not used by
brcmsmac, but it is checked if they are in the archive.

I would still appreciate if Broadcom could release a firmware with
support for the ieee80211 core found in the bcm4716.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 fwcutter/fwcutter.c |  298 +++++++++++++++++++++++++++++++++++++++++++++++----
 fwcutter/fwcutter.h |   31 +++++-
 2 files changed, 305 insertions(+), 24 deletions(-)

diff --git a/fwcutter/fwcutter.c b/fwcutter/fwcutter.c
index 2033758..6f5788c 100644
--- a/fwcutter/fwcutter.c
+++ b/fwcutter/fwcutter.c
@@ -101,6 +101,25 @@ static be32_t to_be32(uint32_t v)
 	return (be32_t)from_be32((be32_t)v);
 }
 
+/* Convert a Little-Endian 32bit integer to CPU-endian */
+static uint32_t from_le32(le32_t v)
+{
+	uint32_t ret = 0;
+
+	ret |= (uint32_t)(((uint8_t *)&v)[0]);
+	ret |= (uint32_t)(((uint8_t *)&v)[1]) << 8;
+	ret |= (uint32_t)(((uint8_t *)&v)[2]) << 16;
+	ret |= (uint32_t)(((uint8_t *)&v)[3]) << 24;
+
+	return ret;
+}
+
+/* Convert a CPU-endian 32bit integer to Little-Endian */
+static le32_t to_le32(uint32_t v)
+{
+	return (le32_t)from_le32((le32_t)v);
+}
+
 /* tiny disassembler */
 static void print_ucode_version(struct insn *insn)
 {
@@ -226,6 +245,27 @@ static void swap_endianness_iv(struct iv *iv)
 	iv->val = bswap_32(iv->val);
 }
 
+static uint8_t *read_object(FILE *f, const struct extract *extract)
+{
+	uint8_t *buf;
+
+	if (fseek(f, extract->offset, SEEK_SET)) {
+		perror("failed to seek on file");
+		exit(2);
+	}
+
+	buf = malloc(extract->length);
+	if (!buf) {
+		perror("failed to allocate buffer");
+		exit(3);
+	}
+	if (fread(buf, 1, extract->length, f) != extract->length) {
+		perror("failed to read complete data");
+		exit(3);
+	}
+	return buf;
+}
+
 static void build_ivs(struct b43_iv **_out, size_t *_out_size,
 		      struct iv *in, size_t in_size,
 		      struct fw_header *hdr,
@@ -328,8 +368,8 @@ static void write_file(const char *name, uint8_t *buf, uint32_t len,
 	fclose(f);
 }
 
-static void extract_or_identify(FILE *f, const struct extract *extract,
-				uint32_t flags)
+static void extract_or_identify(FILE *f, const char *dir,
+				const struct extract *extract, uint32_t flags)
 {
 	uint8_t *buf;
 	size_t data_length;
@@ -339,20 +379,11 @@ static void extract_or_identify(FILE *f, const struct extract *extract,
 	memset(&hdr, 0, sizeof(hdr));
 	hdr.ver = FW_HDR_VER;
 
-	if (fseek(f, extract->offset, SEEK_SET)) {
-		perror("failed to seek on file");
-		exit(2);
-	}
+	printf("%s %s/%s.fw\n",
+	       cmdargs.mode == FWCM_IDENTIFY ? "Contains" : "Extracting",
+	       dir, extract->name);
 
-	buf = malloc(extract->length);
-	if (!buf) {
-		perror("failed to allocate buffer");
-		exit(3);
-	}
-	if (fread(buf, 1, extract->length, f) != extract->length) {
-		perror("failed to read complete data");
-		exit(3);
-	}
+	buf = read_object(f, extract);
 
 	switch (extract->type) {
 	case EXT_UCODE_3:
@@ -390,12 +421,217 @@ static void extract_or_identify(FILE *f, const struct extract *extract,
 		exit(255);
 	}
 
-	if (cmdargs.mode == FWCM_EXTRACT)
+	if (cmdargs.mode == FWCM_EXTRACT_B43)
 		write_file(extract->name, buf, data_length, &hdr, flags);
 
 	free(buf);
 }
 
+static int brcmsmac_name_to_idx(const char *name)
+{
+	if (strcmp("lcn0bsinitvals24", name) == 0) {
+		return D11LCN0BSINITVALS24;
+	} else if (strcmp("lcn0initvals24", name) == 0) {
+		return D11LCN0INITVALS24;
+	} else if (strcmp("lcn1bsinitvals24", name) == 0) {
+		return D11LCN1BSINITVALS24;
+	} else if (strcmp("lcn1initvals24", name) == 0) {
+		return D11LCN1INITVALS24;
+	} else if (strcmp("lcn2bsinitvals24", name) == 0) {
+		return D11LCN2BSINITVALS24;
+	} else if (strcmp("lcn2initvals24", name) == 0) {
+		return D11LCN2INITVALS24;
+	} else if (strcmp("n0absinitvals16", name) == 0) {
+		return D11N0ABSINITVALS16;
+	} else if (strcmp("n0bsinitvals16", name) == 0) {
+		return D11N0BSINITVALS16;
+	} else if (strcmp("n0initvals16", name) == 0) {
+		return D11N0INITVALS16;
+	} else if (strcmp("ucode16_mimo", name) == 0) {
+		return D11UCODE_OVERSIGHT16_MIMO;
+	} else if (strcmp("ucode24_mimo", name) == 0) {
+		return D11UCODE_OVERSIGHT24_LCN;
+	}
+	return 0;
+}
+
+static int brcmsmac_name_to_size_idx(const char *name)
+{
+	if (strcmp("ucode16_mimo", name) == 0) {
+		return D11UCODE_OVERSIGHT16_MIMOSZ;
+	} else if (strcmp("ucode24_mimo", name) == 0) {
+		return D11UCODE_OVERSIGHT24_LCNSZ;
+	}
+	return 0;
+}
+
+static void brcmsmac_clear_file(void)
+{
+	FILE *f;
+	char nbuf[4096];
+	int r;
+
+	r = snprintf(nbuf, sizeof(nbuf),
+		     "%s/brcm", cmdargs.target_dir);
+	if (r >= sizeof(nbuf)) {
+		fprintf(stderr, "name too long");
+		exit(2);
+	}
+
+	r = mkdir(nbuf, 0770);
+	if (r && errno != EEXIST) {
+		perror("failed to create output directory");
+		exit(2);
+	}
+
+	r = snprintf(nbuf, sizeof(nbuf),
+		     "%s/brcm/bcm43xx-0.fw", cmdargs.target_dir);
+	if (r >= sizeof(nbuf)) {
+		fprintf(stderr, "name too long");
+		exit(2);
+	}
+	f = fopen(nbuf, "w");
+	if (!f) {
+		perror("failed to open data file");
+		exit(2);
+	}
+	fclose(f);
+
+	r = snprintf(nbuf, sizeof(nbuf),
+		     "%s/brcm/bcm43xx_hdr-0.fw", cmdargs.target_dir);
+	if (r >= sizeof(nbuf)) {
+		fprintf(stderr, "name too long");
+		exit(2);
+	}
+	f = fopen(nbuf, "w");
+	fclose(f);
+}
+
+static void brcmsmac_write_file(int idx, uint8_t *buf, uint32_t len)
+{
+	FILE *f;
+	FILE *h;
+	char nbuf[4096];
+	int r;
+	int offset;
+	struct firmware_hdr fw_hdr;
+
+	r = snprintf(nbuf, sizeof(nbuf),
+		     "%s/brcm/bcm43xx-0.fw", cmdargs.target_dir);
+	if (r >= sizeof(nbuf)) {
+		fprintf(stderr, "name too long");
+		exit(2);
+	}
+	f = fopen(nbuf, "a");
+	if (!f) {
+		perror("failed to open data file");
+		exit(2);
+	}
+	fseek(f, 0L, SEEK_END);
+
+	r = snprintf(nbuf, sizeof(nbuf),
+		     "%s/brcm/bcm43xx_hdr-0.fw", cmdargs.target_dir);
+	if (r >= sizeof(nbuf)) {
+		fprintf(stderr, "name too long");
+		exit(2);
+	}
+	h = fopen(nbuf, "a");
+	if (!h) {
+		perror("failed to open header file");
+		exit(2);
+	}
+	fseek(h, 0L, SEEK_END);
+
+	offset = ftell(f);
+
+	fw_hdr.offset = to_le32(offset);
+	fw_hdr.len = to_le32(len);
+	fw_hdr.idx = to_le32(idx);
+
+	if (fwrite(&fw_hdr, sizeof(fw_hdr), 1, h) != 1) {
+		perror("failed to write file");
+		exit(2);
+	}
+	fclose(h);
+	if (fwrite(buf, 1, len, f) != len) {
+		perror("failed to write file");
+		exit(2);
+	}
+	fclose(f);
+}
+
+static void brcmsmac_add_dummy_entries(void)
+{
+	uint8_t buf[4] = {0};
+
+	brcmsmac_write_file(D11N0ABSINITVALS16, buf, 4);
+	brcmsmac_write_file(D11UCODE_OVERSIGHT_BOMMAJOR, buf, 4);
+	brcmsmac_write_file(D11UCODE_OVERSIGHT_BOMMINOR, buf, 4);
+}
+
+static void brcmsmac_extract(FILE *f, const struct extract *extract,
+			     uint32_t flags)
+{
+	uint8_t *buf;
+	size_t data_length;
+	int ucode_rev = 0;
+	int brcmsmac_idx = 0;
+	be32_t size;
+
+
+	brcmsmac_idx = brcmsmac_name_to_idx(extract->name);
+	if (!brcmsmac_idx)
+		return;
+	printf("%s %s\n",
+	       cmdargs.mode == FWCM_IDENTIFY ? "Contains" : "Extracting",
+	       extract->name);
+
+	buf = read_object(f, extract);
+
+	switch (extract->type) {
+	case EXT_UCODE_3:
+		ucode_rev += 1;
+	case EXT_UCODE_2:
+		ucode_rev += 1;
+	case EXT_UCODE_1:
+		ucode_rev += 1;
+		data_length = extract->length;
+		if (flags & FW_FLAG_LE)
+			swap_endianness_ucode(buf, data_length);
+		analyse_ucode(ucode_rev, buf, data_length);
+		swap_endianness_ucode(buf, data_length);
+		size = to_le32(data_length);
+		break;
+	case EXT_PCM:
+		data_length = extract->length;
+		if (!(flags & FW_FLAG_LE))
+			swap_endianness_pcm(buf, data_length);
+		size = to_le32(data_length);
+		break;
+	case EXT_IV: {
+		data_length = extract->length;
+		if (!(flags & FW_FLAG_LE)) {
+			struct iv *in = (struct iv *)buf;
+			int i;
+
+			for (i = 0; i < data_length / sizeof(struct iv); i++, in++)
+				swap_endianness_iv(in);
+		}
+		size = to_le32(data_length);
+		break;
+	}
+	default:
+		exit(255);
+	}
+
+	brcmsmac_write_file(brcmsmac_idx, buf, data_length);
+	int size_idx = brcmsmac_name_to_size_idx(extract->name);
+	if (size_idx)
+		brcmsmac_write_file(size_idx, (uint8_t *)&size, 4);
+
+	free(buf);
+}
+
 static void print_banner(void)
 {
 	printf("b43-fwcutter version " FWCUTTER_VERSION "\n");
@@ -497,6 +733,8 @@ static void print_usage(int argc, char *argv[])
 	       "Allow working on extractable but unsupported drivers\n");
 	printf("  -l|--list             "
 	       "List supported driver versions\n");
+	printf("  -b|--brcmsmac         "
+	       "create firmware for brcmsmac\n");
 	printf("  -i|--identify         "
 	       "Only identify the driver file (don't extract)\n");
 	printf("  -w|--target-dir DIR   "
@@ -608,6 +846,13 @@ static int parse_args(int argc, char *argv[])
 		} else if (res == ARG_ERROR)
 			goto out;
 
+		res = cmp_arg(argv, &i, "--brcmsmac", "-b", NULL);
+		if (res == ARG_MATCH) {
+			cmdargs.mode = FWCM_EXTRACT_BRCMSMAC;
+			continue;
+		} else if (res == ARG_ERROR)
+			goto out;
+
 		res = cmp_arg(argv, &i, "--unsupported", NULL, NULL);
 		if (res == ARG_MATCH) {
 			cmdargs.unsupported = 1;
@@ -672,13 +917,20 @@ int main(int argc, char *argv[])
 	else
 		dir = V3_FW_DIRNAME;
 
-	extract = file->extract;
-	while (extract->name) {
-		printf("%s %s/%s.fw\n",
-		       cmdargs.mode == FWCM_IDENTIFY ? "Contains" : "Extracting",
-		       dir, extract->name);
-		extract_or_identify(fd, extract, file->flags);
-		extract++;
+	if (cmdargs.mode == FWCM_EXTRACT_BRCMSMAC) {
+		brcmsmac_clear_file();
+		extract = file->extract;
+		while (extract->name) {
+			brcmsmac_extract(fd, extract, file->flags);
+			extract++;
+		}
+		brcmsmac_add_dummy_entries();
+	} else {
+		extract = file->extract;
+		while (extract->name) {
+			extract_or_identify(fd, dir, extract, file->flags);
+			extract++;
+		}
 	}
 
 	err = 0;
diff --git a/fwcutter/fwcutter.h b/fwcutter/fwcutter.h
index c6d3c3f..a441322 100644
--- a/fwcutter/fwcutter.h
+++ b/fwcutter/fwcutter.h
@@ -15,6 +15,8 @@
 typedef uint16_t be16_t; /* Big-endian 16bit */
 typedef uint32_t be32_t; /* Big-endian 32bit */
 
+typedef uint32_t le32_t; /* Little-endian 32bit */
+
 #if defined(__DragonFly__) || defined(__FreeBSD__)
 #define bswap_16	bswap16
 #define bswap_32	bswap32
@@ -25,9 +27,10 @@ typedef uint32_t be32_t; /* Big-endian 32bit */
 #define ARG_ERROR	-1
 
 enum fwcutter_mode {
-	FWCM_EXTRACT = 0,	/* default */
+	FWCM_EXTRACT_B43 = 0,	/* default */
 	FWCM_LIST,
 	FWCM_IDENTIFY,
+	FWCM_EXTRACT_BRCMSMAC,
 };
 
 struct cmdline_args {
@@ -104,5 +107,31 @@ struct b43_iv {
 #define FW_IV_OFFSET_MASK	0x7FFF
 #define FW_IV_32BIT		0x8000
 
+/* header format for brcmsmac firmware */
+struct firmware_hdr {
+	le32_t offset;
+	le32_t len;
+	le32_t idx;
+};
+
+/* numbers of firmware types for brcmsmac firmware */
+enum firmware_brcmsmac {
+	D11UCODE_NAMETAG_START = 0,
+	D11LCN0BSINITVALS24,
+	D11LCN0INITVALS24,
+	D11LCN1BSINITVALS24,
+	D11LCN1INITVALS24,
+	D11LCN2BSINITVALS24,
+	D11LCN2INITVALS24,
+	D11N0ABSINITVALS16,
+	D11N0BSINITVALS16,
+	D11N0INITVALS16,
+	D11UCODE_OVERSIGHT16_MIMO,
+	D11UCODE_OVERSIGHT16_MIMOSZ,
+	D11UCODE_OVERSIGHT24_LCN,
+	D11UCODE_OVERSIGHT24_LCNSZ,
+	D11UCODE_OVERSIGHT_BOMMAJOR,
+	D11UCODE_OVERSIGHT_BOMMINOR
+};
 
 #endif /* _FWCUTTER_H_ */
-- 
1.7.9.5

