Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E1F2DEA8F;
	Sun, 30 Aug 2026 13:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788098017; cv=none; b=QgTLn9F/3I/ph6SQx03Q8lO13h8wNkUjF8n1sVv3RNZGhY+c9TO/qHLiQhtbf+g0eyKP0EvBgF1vSbNBwaBVP3Gf1rJdJUhmmHCC0k9MJ4OKarMJHjACLi2dDt9T3rUZNF3GM4k5fCBk2nuTQ/qRYGK7bZD8eEZ2Q4bQ08sqVTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788098017; c=relaxed/simple;
	bh=tlIbwTUgkcBAud4kij9O5hh8lWbL8//g9iLDC8472vA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jfumsAsyRwjJbjtwB6kJhBeNQo+T3qPRP7leS1s0wfsyQGil+39bJ6QqIvZBfnsaAUCzz4gbepUJEt7Vsc7NdDZxY8WePbWqbtt6sw8g/6ZjN5onGjSTeQw74Eda0vqLxt+1DYM7FpM3KQmehhw/wAaPETvOKOhG1ZOLrBibxjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowABnckDaNZRqyWCbBg--.18164S2;
	Sun, 30 Aug 2026 21:53:31 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: brcmfmac: bound NVRAM comment parsing
Date: Sun, 30 Aug 2026 21:53:28 +0800
Message-ID: <20260830135328.12321-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABnckDaNZRqyWCbBg--.18164S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXw4kCw4Utr4UXF48Kr13CFg_yoW5Jw18pr
	Z3Wa1j9rs8Ja9ayrW5Kr43Xr9YgFn3K3srKFWrA3WSvFs8Ar1rZw1kKFyS9F4YyFy8Jay7
	trWDtr98Xw4Dt37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvj14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j
	6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfU08
	9NUUUUU
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

The NVRAM parser tracks a length-bounded firmware blob but its comment
handler uses unbounded strchr() calls. A comment without a newline or NUL
inside the remaining blob can make the search read beyond the current
input.

Store the bounded input length and use memchr() for comment terminators.

Fixes: 3e99b08ab53c ("brcmfmac: enhance nvram processing")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/firmware.c    | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 22ff326f1924a..c68dee6d7b344 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -37,6 +37,7 @@ enum nvram_parser_state {
  *
  * @state: current parser state.
  * @data: input buffer being parsed.
+ * @data_len: size of the input buffer.
  * @nvram: output buffer with parse result.
  * @nvram_len: length of parse result.
  * @line: current line.
@@ -51,6 +52,7 @@ enum nvram_parser_state {
 struct nvram_parser {
 	enum nvram_parser_state state;
 	const u8 *data;
+	u32 data_len;
 	u8 *nvram;
 	u32 nvram_len;
 	u32 line;
@@ -171,12 +173,15 @@ brcmf_nvram_handle_value(struct nvram_parser *nvp)
 static enum nvram_parser_state
 brcmf_nvram_handle_comment(struct nvram_parser *nvp)
 {
-	char *eoc, *sol;
+	char *eoc;
+	char *sol;
+	size_t remaining;
 
 	sol = (char *)&nvp->data[nvp->pos];
-	eoc = strchr(sol, '\n');
+	remaining = nvp->data_len - nvp->pos;
+	eoc = memchr(sol, '\n', remaining);
 	if (!eoc) {
-		eoc = strchr(sol, '\0');
+		eoc = memchr(sol, '\0', remaining);
 		if (!eoc)
 			return END;
 	}
@@ -215,6 +220,7 @@ static int brcmf_init_nvram_parser(struct nvram_parser *nvp,
 		size = BRCMF_FW_MAX_NVRAM_SIZE;
 	else
 		size = data_len;
+	nvp->data_len = size;
 	/* Add space for properties we may add */
 	size += strlen(BRCMF_FW_DEFAULT_BOARDREV) + 1;
 	size += BRCMF_FW_MACADDR_LEN + 1;
@@ -408,7 +414,7 @@ static void *brcmf_fw_nvram_strip(const u8 *data, size_t data_len,
 	if (eth_platform_get_mac_address(dev, mac) == 0)
 		nvp.strip_mac = true;
 
-	while (nvp.pos < data_len) {
+	while (nvp.pos < nvp.data_len) {
 		nvp.state = nv_parser_states[nvp.state](&nvp);
 		if (nvp.state == END)
 			break;

base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
-- 
2.50.1

