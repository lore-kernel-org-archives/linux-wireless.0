Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793542328;
	b=WBTRwjbX5bLNKQ9pzPphxvuXJmTb+MvBIarBS1oS1OK29bjrMyQeSibLHi4y17MGdO9s
	 Trxq/L8yB/FB68itVWJOkqkJSlubB6IJWamiq2oWMpmgiHAgjkxK4aKa1IkxgojVBb5Yj
	 gz/33gG5+WErqcq5dbg1vni3nOdQ3iz3yy+yZtakmNhCzpzQKyUhDuDjzE5Beva5RKjCt
	 XI++3Dp6w7CXatzjXreBBZ0AbAGcTnY8YzxBjlBU4857LbMgniweChaKYrJYVsOwacYBC
	 elOykinEt/H+jxjx0NCUuzg9QnMMPP58F1tRhMoPvsTrG4XEAQU5b12QonBGunGa3EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793542328;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=vKAXOL23MUbpcmgi848SNQY3bn3NMm69gWaN38hxAqM=;
	b=RHP9GRbwQLUJCpvDfjgHIdgrB4Cw85c/JATEE9B8R3IVCsswWfhoj1avW6n8KRZKCjzi
	 jQd6OomnZqkj81b+gUDsWbYFyeDXZc6Kt2bA7YkiJ4+20pgtx2Kjc5bfvn4lfQMY3V3fN
	 k9I2Cc7GffkUMHxkSeceSBU5qMZ6xcTg354b7ZUY/RvwsdA3H+P8Nx/BDEg1hHXvhKt/a
	 d3eZVAw9yJ9AqmZJdAmh2IgYSTNlsYJT/BoGfym/hSbjCPW1vN4B4yjM5M40zGFX2/s2l
	 ArdWsJx6b0+hB7tpr0EngXcAIZgQJNNO1xAx7D23n9z+syUnmfTwxZGyfJJzUm3Vtzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=LJ3OmnvE;
	arc=none smtp.remote-ip=220.197.31.4
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3291B606A324;
	Sun,  1 Nov 2026 14:12:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3291B606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=LJ3OmnvE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=vK
	AXOL23MUbpcmgi848SNQY3bn3NMm69gWaN38hxAqM=; b=LJ3OmnvE1IIpzCay2K
	n4ic9bxPTpbmJeyNSrc2JoTDtu96ygYq2or8Eq8hwit4Rj+FPmLVx86BShJEr0QK
	DuXo1tBmJqmTQz8xEQ5rAXxc/oSLrCIcmlqemDA1BWdi+H42wEXgcovQik4R97CO
	38XqnIFkaWilK+IFtx8XrK0PM=
Received: from LAPTOP-BJS5C4G0 (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3P0WjSOdqIoObEg--.37504S2;
	Sun, 01 Nov 2026 22:11:49 +0800 (CST)
From: Heyang Tan <thy15333007817@163.com>
To: linux-wireless@vger.kernel.org,
	lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com,
	arien.judge@morsemicro.com
Cc: johannes@sipsolutions.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mm81x: validate firmware and BCF ELF bounds
Date: Sun,  1 Nov 2026 22:11:43 +0800
Message-ID: <20261101141144.551-1-thy15333007817@163.com>
X-Mailer: git-send-email 2.51.0.windows.1
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3P0WjSOdqIoObEg--.37504S2
X-Coremail-Antispam: 1Uf129KBjvAXoW3Cw4DGF1DGFyrZFyxXrW8WFg_yoW8XrWUAo
	WSqFZxG3yYgr15WrWvkF17CFn8Ww4kt3s5Ja15X3yUua1jvw4UCFn3WFW3JayUu3WYkFZ3
	AaySqrW8XFW2vryrn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUOa0mUUUUU
X-CM-SenderInfo: 5wk1ikatttiiixyrlqqrwthudrp/xtbC4gbPeWrnSKbFmQAA3t

The mm81x firmware and BCF loaders trust the ELF header, program header,
section header, section name, and firmware-info TLV fields.  They do not
verify that the header exists in the supplied image, that the program and
section tables fit, that section data is in bounds, or that section names
are NUL-terminated within the string table.

A malformed firmware or BCF image can therefore make the loader read past
the end of the firmware buffer before the device is programmed.  Program
segment offsets and sizes also need a range check before copying a segment
into the scratch buffer, and the firmware-info TLV walk must verify that
both its header and payload are present.

Validate the ELF layout once when reading the header, add overflow-safe
range helpers for tables and sections, validate the string table before
looking up names, and bounds-check program segments and firmware-info TLVs
before using them.  Reject malformed images instead of silently continuing.

A KASAN reproducer with a section header placed immediately after the
supplied image reports a slab-out-of-bounds; the same input is rejected by
these range checks.

Signed-off-by: Heyang Tan <thy15333007817@163.com>
---
 drivers/net/wireless/morsemicro/mm81x/fw.c | 338 ++++++++++++++-------
 1 file changed, 230 insertions(+), 108 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/fw.c b/drivers/net/wireless/morsemicro/mm81x/fw.c
index d6d2ad086..235cd0a30 100644
--- a/drivers/net/wireless/morsemicro/mm81x/fw.c
+++ b/drivers/net/wireless/morsemicro/mm81x/fw.c
@@ -25,11 +25,19 @@
 /* Number of times to attempt flashing FW */
 #define FW_FLASH_ATTEMPT_COUNT 3
 
-static int mm81x_fw_get_header(const u8 *data, Elf32_Ehdr *ehdr)
+static bool mm81x_fw_range_valid(size_t size, u32 offset, size_t length)
+{
+	return offset <= size && length <= size - offset;
+}
+
+static int mm81x_fw_get_header(const u8 *data, size_t size, Elf32_Ehdr *ehdr)
 {
 	const struct mm81x_elf32_ehdr *p =
 		(const struct mm81x_elf32_ehdr *)data;
 
+	if (size < sizeof(*p))
+		return -EINVAL;
+
 	/* Magic check */
 	if (p->e_ident[EI_MAG0] != ELFMAG0 || p->e_ident[EI_MAG1] != ELFMAG1 ||
 	    p->e_ident[EI_MAG2] != ELFMAG2 || p->e_ident[EI_MAG3] != ELFMAG3)
@@ -49,35 +57,69 @@ static int mm81x_fw_get_header(const u8 *data, Elf32_Ehdr *ehdr)
 	ehdr->e_shstrndx = le16_to_cpu(p->e_shstrndx);
 	ehdr->e_entry = le32_to_cpu(p->e_entry);
 
+	if (ehdr->e_phnum &&
+	    (ehdr->e_phentsize != sizeof(struct mm81x_elf32_phdr) ||
+	     !mm81x_fw_range_valid(size, ehdr->e_phoff,
+				   (size_t)ehdr->e_phnum * ehdr->e_phentsize)))
+		return -EINVAL;
+
+	if (!ehdr->e_shnum ||
+	    ehdr->e_shentsize != sizeof(struct mm81x_elf32_shdr) ||
+	    ehdr->e_shstrndx == SHN_UNDEF || ehdr->e_shstrndx >= ehdr->e_shnum ||
+	    !mm81x_fw_range_valid(size, ehdr->e_shoff,
+				  (size_t)ehdr->e_shnum * ehdr->e_shentsize))
+		return -EINVAL;
+
 	return 0;
 }
 
-static void mm81x_fw_parse_info(struct mm81x *mors, const u8 *data, int length)
+static int mm81x_fw_parse_info(struct mm81x *mors, const u8 *data, size_t length)
 {
-	const struct mm81x_fw_info_tlv *tlv =
-		(const struct mm81x_fw_info_tlv *)data;
+	const u8 *pos = data;
+	const u8 *end = data + length;
+
+	while (pos < end) {
+		const struct mm81x_fw_info_tlv *tlv;
+		size_t tlv_len;
+
+		if (end - pos < sizeof(*tlv))
+			break;
+
+		tlv = (const struct mm81x_fw_info_tlv *)pos;
+		tlv_len = le16_to_cpu(tlv->length);
+		if (tlv_len > end - pos - sizeof(*tlv))
+			return -EINVAL;
 
-	while ((u8 *)tlv < (data + length)) {
 		switch (le16_to_cpu(tlv->type)) {
 		case MM81X_FW_INFO_TLV_BCF_ADDR:
+			if (tlv_len < sizeof(__le32))
+				return -EINVAL;
 			mors->bcf_address = get_unaligned_le32(tlv->val);
 			break;
 		default:
 			break;
 		}
-		tlv = (const struct mm81x_fw_info_tlv *)((u8 *)tlv +
-							 le16_to_cpu(
-								 tlv->length) +
-							 sizeof(*tlv));
+
+		pos += sizeof(*tlv) + tlv_len;
 	}
+
+	return 0;
 }
 
-static int mm81x_fw_get_section_header(const u8 *data, Elf32_Ehdr *ehdr,
-				       Elf32_Shdr *shdr, int i)
+static int mm81x_fw_get_section_header(const u8 *data, size_t size,
+				       Elf32_Ehdr *ehdr, Elf32_Shdr *shdr, int i)
 {
-	const struct mm81x_elf32_shdr *p =
-		(void *)(data + ehdr->e_shoff + (i * ehdr->e_shentsize));
+	const struct mm81x_elf32_shdr *p;
+	size_t offset;
+
+	if (i < 0 || i >= ehdr->e_shnum)
+		return -EINVAL;
 
+	offset = ehdr->e_shoff + (size_t)i * ehdr->e_shentsize;
+	if (!mm81x_fw_range_valid(size, offset, sizeof(*p)))
+		return -EINVAL;
+
+	p = (const void *)(data + offset);
 	shdr->sh_name = le32_to_cpu(p->sh_name);
 	shdr->sh_type = le32_to_cpu(p->sh_type);
 	shdr->sh_offset = le32_to_cpu(p->sh_offset);
@@ -88,6 +130,22 @@ static int mm81x_fw_get_section_header(const u8 *data, Elf32_Ehdr *ehdr,
 	return 0;
 }
 
+static const char *mm81x_fw_get_section_name(const u8 *data,
+					     const Elf32_Shdr *strtab,
+					     const Elf32_Shdr *shdr)
+{
+	const char *name;
+
+	if (!strtab->sh_size || shdr->sh_name >= strtab->sh_size)
+		return NULL;
+
+	name = (const char *)data + strtab->sh_offset + shdr->sh_name;
+	if (!memchr(name, '\0', strtab->sh_size - shdr->sh_name))
+		return NULL;
+
+	return name;
+}
+
 static int mm81x_fw_set_boot_addr(struct mm81x *mors, uint32_t addr)
 {
 	int status;
@@ -101,88 +159,119 @@ static int mm81x_fw_set_boot_addr(struct mm81x *mors, uint32_t addr)
 
 static int mm81x_fw_load_fw(struct mm81x *mors, const struct firmware *fw)
 {
-	int i;
-	int ret = 0;
 	Elf32_Ehdr ehdr;
 	Elf32_Phdr phdr;
 	Elf32_Shdr shdr;
 	Elf32_Shdr sh_strtab;
-	const char *sh_strs;
+	size_t fw_size_rounded;
+	u8 *fw_buf;
+	int i;
+	int ret;
 
-	u8 *fw_buf = devm_kmalloc(mors->dev, ROUND_BYTES_TO_WORD(fw->size),
-				  GFP_KERNEL);
+	if (fw->size > U32_MAX - 3)
+		return -EFBIG;
 
+	fw_size_rounded = ROUND_BYTES_TO_WORD(fw->size);
+	fw_buf = devm_kmalloc(mors->dev, fw_size_rounded, GFP_KERNEL);
 	if (!fw_buf)
 		return -ENOMEM;
 
-	if (mm81x_fw_get_header(fw->data, &ehdr)) {
+	ret = mm81x_fw_get_header(fw->data, fw->size, &ehdr);
+	if (ret) {
 		dev_err(mors->dev, "Wrong file format");
-		return -EINVAL;
+		goto err_free;
 	}
 
-	if (mm81x_fw_get_section_header(fw->data, &ehdr, &sh_strtab,
-					ehdr.e_shstrndx)) {
-		dev_err(mors->dev, "Invalid firmware. Missing string table");
-		return -ENOENT;
+	ret = mm81x_fw_get_section_header(fw->data, fw->size, &ehdr,
+					  &sh_strtab, ehdr.e_shstrndx);
+	if (ret || sh_strtab.sh_type != SHT_STRTAB ||
+	    !mm81x_fw_range_valid(fw->size, sh_strtab.sh_offset,
+				  sh_strtab.sh_size)) {
+		dev_err(mors->dev, "Invalid firmware string table");
+		ret = -EINVAL;
+		goto err_free;
 	}
 
-	sh_strs = (const char *)fw->data + sh_strtab.sh_offset;
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		const char *name;
+
+		ret = mm81x_fw_get_section_header(fw->data, fw->size, &ehdr,
+						  &shdr, i);
+		if (ret)
+			goto err_free;
+
+		if (!mm81x_fw_range_valid(fw->size, shdr.sh_offset,
+					  shdr.sh_size))
+			goto invalid;
+
+		name = mm81x_fw_get_section_name(fw->data, &sh_strtab, &shdr);
+		if (!name)
+			goto invalid;
+
+		if (!strcmp(name, ".fw_info")) {
+			ret = mm81x_fw_parse_info(mors, fw->data + shdr.sh_offset,
+						  shdr.sh_size);
+			if (ret)
+				goto err_free;
+		}
+	}
 
 	for (i = 0; i < ehdr.e_phnum; i++) {
+		const struct mm81x_elf32_phdr *p;
+		size_t offset = ehdr.e_phoff + (size_t)i * ehdr.e_phentsize;
+		size_t padded_size;
+		u32 address;
 		int status;
-		int address;
-		const struct mm81x_elf32_phdr *p =
-			(void *)(fw->data + ehdr.e_phoff +
-				 i * ehdr.e_phentsize);
 
+		p = (const void *)(fw->data + offset);
 		phdr.p_type = le32_to_cpu(p->p_type);
 		phdr.p_offset = le32_to_cpu(p->p_offset);
 		phdr.p_paddr = le32_to_cpu(p->p_paddr);
 		phdr.p_filesz = le32_to_cpu(p->p_filesz);
 		phdr.p_memsz = le32_to_cpu(p->p_memsz);
 
-		address = phdr.p_paddr;
-
 		if (phdr.p_type != PT_LOAD || !phdr.p_memsz)
 			continue;
+		if (phdr.p_filesz > phdr.p_memsz)
+			goto invalid;
+		if (!phdr.p_filesz || !phdr.p_offset)
+			continue;
+		if (!mm81x_fw_range_valid(fw->size, phdr.p_offset,
+					  phdr.p_filesz))
+			goto invalid;
 
-		if (phdr.p_filesz && phdr.p_offset &&
-		    (phdr.p_offset + phdr.p_filesz) < fw->size) {
-			u32 padded_size = ROUND_BYTES_TO_WORD(phdr.p_filesz);
-
-			memcpy(fw_buf, fw->data + phdr.p_offset, padded_size);
-			/* Set padding to 0xff */
-			memset(fw_buf + phdr.p_filesz, 0xff,
-			       padded_size - phdr.p_filesz);
-			mm81x_claim_bus(mors);
-			status = mm81x_dm_write(mors, address, fw_buf,
-						padded_size);
-			mm81x_release_bus(mors);
-			if (status) {
-				ret = -EIO;
-				break;
-			}
+		padded_size = ROUND_BYTES_TO_WORD(phdr.p_filesz);
+		if (padded_size > fw_size_rounded || padded_size > INT_MAX)
+			goto invalid;
+
+		memcpy(fw_buf, fw->data + phdr.p_offset, phdr.p_filesz);
+		memset(fw_buf + phdr.p_filesz, 0xff,
+		       padded_size - phdr.p_filesz);
+		address = phdr.p_paddr;
+		mm81x_claim_bus(mors);
+		status = mm81x_dm_write(mors, address, fw_buf, padded_size);
+		mm81x_release_bus(mors);
+		if (status) {
+			ret = -EIO;
+			goto err_free;
 		}
 	}
 
-	for (i = 0; i < ehdr.e_shnum; i++) {
-		if (mm81x_fw_get_section_header(fw->data, &ehdr, &shdr, i))
-			continue;
-
-		/* This is the firmware info. Parse it */
-		if (!strncmp(sh_strs + shdr.sh_name, ".fw_info",
-			     sizeof(".fw_info")))
-			mm81x_fw_parse_info(mors, fw->data + shdr.sh_offset,
-					    shdr.sh_size);
+	if (ehdr.e_entry) {
+		ret = mm81x_fw_set_boot_addr(mors, ehdr.e_entry);
+		if (ret)
+			goto err_free;
 	}
 
-	if (ehdr.e_entry)
-		ret = mm81x_fw_set_boot_addr(mors, ehdr.e_entry);
+	ret = 0;
+	goto err_free;
 
+invalid:
+	ret = -EINVAL;
+err_free:
 	devm_kfree(mors->dev, fw_buf);
 	return ret;
 }
-
 static int __mm81x_fw_load_bcf(struct mm81x *mors, unsigned int addr,
 			       const void *src, size_t src_len, u8 *scratch,
 			       size_t scratch_cap)
@@ -209,93 +298,126 @@ static int __mm81x_fw_load_bcf(struct mm81x *mors, unsigned int addr,
 static int mm81x_fw_load_bcf(struct mm81x *mors, const struct firmware *bcf,
 			     unsigned int bcf_address)
 {
-	int i, ret = 0;
-	size_t reg_prefix_len, cfg_len_rounded = 0, reg_len_rounded;
+	const char *reg_prefix = ".regdom_";
+	const u8 *cfg_src = NULL;
+	const u8 *reg_src = NULL;
+	const char *reg_name = NULL;
+	size_t bcf_size_rounded;
+	size_t reg_prefix_len;
+	size_t cfg_len = 0;
+	size_t reg_len = 0;
+	size_t cfg_len_rounded;
+	size_t reg_len_rounded;
 	Elf32_Ehdr ehdr;
-	Elf32_Shdr shdr, sh_strtab;
-	const char *sh_strs, *reg_prefix = ".regdom_", *reg_src;
-	size_t reg_len;
+	Elf32_Shdr shdr;
+	Elf32_Shdr sh_strtab;
 	u8 *bcf_buf;
+	int i;
+	int ret;
+
+	if (bcf->size > U32_MAX - 3)
+		return -EFBIG;
 
-	bcf_buf = devm_kmalloc(mors->dev, ROUND_BYTES_TO_WORD(bcf->size),
-			       GFP_KERNEL);
+	bcf_size_rounded = ROUND_BYTES_TO_WORD(bcf->size);
+	bcf_buf = devm_kmalloc(mors->dev, bcf_size_rounded, GFP_KERNEL);
 	if (!bcf_buf)
 		return -ENOMEM;
 
-	if (mm81x_fw_get_header(bcf->data, &ehdr)) {
+	ret = mm81x_fw_get_header(bcf->data, bcf->size, &ehdr);
+	if (ret) {
 		dev_err(mors->dev, "Wrong file format");
-		ret = -EINVAL;
 		goto out_free;
 	}
 
-	if (mm81x_fw_get_section_header(bcf->data, &ehdr, &sh_strtab,
-					ehdr.e_shstrndx)) {
-		dev_err(mors->dev, "Invalid BCF - missing string table");
-		ret = -ENOENT;
+	ret = mm81x_fw_get_section_header(bcf->data, bcf->size, &ehdr,
+					  &sh_strtab, ehdr.e_shstrndx);
+	if (ret || sh_strtab.sh_type != SHT_STRTAB ||
+	    !mm81x_fw_range_valid(bcf->size, sh_strtab.sh_offset,
+				  sh_strtab.sh_size)) {
+		dev_err(mors->dev, "Invalid BCF string table");
+		ret = -EINVAL;
 		goto out_free;
 	}
 
-	sh_strs = (const char *)bcf->data + sh_strtab.sh_offset;
 	reg_prefix_len = strlen(reg_prefix);
 
 	for (i = 0; i < ehdr.e_shnum; i++) {
-		if (mm81x_fw_get_section_header(bcf->data, &ehdr, &shdr, i))
-			continue;
-		if (strcmp(sh_strs + shdr.sh_name, ".board_config"))
-			continue;
+		const char *name;
+		size_t name_len;
 
-		cfg_len_rounded = ROUND_BYTES_TO_WORD(shdr.sh_size);
-		dev_dbg(mors->dev,
-			"Write BCF board_config - addr 0x%x size %zu",
-			bcf_address, cfg_len_rounded);
-
-		ret = __mm81x_fw_load_bcf(mors, bcf_address,
-					  bcf->data + shdr.sh_offset,
-					  shdr.sh_size, bcf_buf,
-					  ROUND_BYTES_TO_WORD(bcf->size));
+		ret = mm81x_fw_get_section_header(bcf->data, bcf->size, &ehdr,
+						  &shdr, i);
 		if (ret)
 			goto out_free;
 
-		bcf_address += cfg_len_rounded;
-		break;
-	}
+		if (!mm81x_fw_range_valid(bcf->size, shdr.sh_offset,
+					  shdr.sh_size)) {
+			ret = -EINVAL;
+			goto out_free;
+		}
 
-	ret = -EINVAL;
-	for (; i < ehdr.e_shnum; i++) {
-		if (mm81x_fw_get_section_header(bcf->data, &ehdr, &shdr, i))
-			continue;
-		if (strncmp(sh_strs + shdr.sh_name, reg_prefix, reg_prefix_len))
+		name = mm81x_fw_get_section_name(bcf->data, &sh_strtab, &shdr);
+		if (!name) {
+			ret = -EINVAL;
+			goto out_free;
+		}
+
+		if (!strcmp(name, ".board_config")) {
+			if (!cfg_src) {
+				cfg_src = bcf->data + shdr.sh_offset;
+				cfg_len = shdr.sh_size;
+			}
 			continue;
-		if (strncmp(sh_strs + shdr.sh_name + reg_prefix_len,
-			    mors->country, 2))
+		}
+
+		name_len = strnlen(name, sh_strtab.sh_size - shdr.sh_name);
+		if (name_len < reg_prefix_len + 2 ||
+		    strncmp(name, reg_prefix, reg_prefix_len) ||
+		    strncmp(name + reg_prefix_len, mors->country, 2))
 			continue;
 
-		reg_src = bcf->data + shdr.sh_offset;
-		reg_len = shdr.sh_size;
-		dev_dbg(mors->dev, "Write BCF %s - addr 0x%x size %zu",
-			sh_strs + shdr.sh_name, bcf_address,
-			ROUND_BYTES_TO_WORD(reg_len));
-		ret = 0;
-		break;
+		if (!reg_src) {
+			reg_src = bcf->data + shdr.sh_offset;
+			reg_len = shdr.sh_size;
+			reg_name = name;
+		}
+	}
+
+	if (!cfg_src || !cfg_len || !reg_src || !reg_len) {
+		ret = -EINVAL;
+		goto out_free;
 	}
 
+	cfg_len_rounded = ROUND_BYTES_TO_WORD(cfg_len);
+	reg_len_rounded = ROUND_BYTES_TO_WORD(reg_len);
+	if (cfg_len_rounded > U32_MAX ||
+	    (cfg_len_rounded + reg_len_rounded) > BCF_DATABASE_SIZE) {
+		ret = -EFBIG;
+		goto out_free;
+	}
+
+	dev_dbg(mors->dev, "Write BCF board_config - addr 0x%x size %zu",
+		bcf_address, cfg_len_rounded);
+	ret = __mm81x_fw_load_bcf(mors, bcf_address, cfg_src, cfg_len,
+				  bcf_buf, bcf_size_rounded);
 	if (ret)
 		goto out_free;
 
-	reg_len_rounded = ROUND_BYTES_TO_WORD(reg_len);
-	if ((cfg_len_rounded + reg_len_rounded) > BCF_DATABASE_SIZE) {
+	if (bcf_address > U32_MAX - cfg_len_rounded) {
 		ret = -EFBIG;
 		goto out_free;
 	}
+	bcf_address += cfg_len_rounded;
 
-	ret = __mm81x_fw_load_bcf(mors, bcf_address, reg_src, reg_len, bcf_buf,
-				  ROUND_BYTES_TO_WORD(bcf->size));
+	dev_dbg(mors->dev, "Write BCF %s - addr 0x%x size %zu",
+		reg_name, bcf_address, reg_len_rounded);
+	ret = __mm81x_fw_load_bcf(mors, bcf_address, reg_src, reg_len,
+				  bcf_buf, bcf_size_rounded);
 
 out_free:
 	devm_kfree(mors->dev, bcf_buf);
 	return ret;
 }
-
 static void mm81x_fw_clear_aon(struct mm81x *mors)
 {
 	int idx;

