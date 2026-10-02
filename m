Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33AE2E718B
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790953289; cv=none; b=E4tmu/z6HUzBuJxVJ6jJr7yUFZxtg8Y9NObNIwZFspDXbYPXNOj11/+M7X1+Nf03g0pNdV6hjH+EwvADOjeErmfJ8vO7x/1dXfiiTjaZAFjtPVpWVUIaR0kSWRLLB1jfVrQbrJfX/gaAeDCS1fz2pachBHVVxYmgRVNkV542XqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790953289; c=relaxed/simple;
	bh=ShR78d2EjI1Kut4vJt9V0tyGLW84tjXkCQvZuKH1+7M=;
	h=From:Date:Subject:To:Cc:Message-ID:MIME-Version:Content-Type; b=sbvatt/BSlZkMB/SlpOZ0cmvnKg4huroro2TQ+CCKtv4urY+QvG+8NNvD2Xv5/wtHJcwxOeIOVvTxHkNyBWi+CAPRp4Hq5H7KYjfgr9yfoHRmaFTCJRMfKTeWWrW4IIj19c7z8New4VZWTjRTd2LC1DA1WcR6nCkVaN2V9jgIVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZN8Rm/O4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZN8Rm/O4"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85303C2BCF4;
	Fri,  2 Oct 2026 15:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790953289;
	bh=ShR78d2EjI1Kut4vJt9V0tyGLW84tjXkCQvZuKH1+7M=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=ZN8Rm/O4t21i1pLeOL2SAbVEYHJnwlhwSeQ3KKgUu81SgeCXY7JlE8YtBovfLMkhS
	 NHW72nCGG3156mdxiNzPV9ksTNjkBUd6YHz04QXS+xG/I3Pjy7/x2pLPyWZ4wfCquD
	 H+UB0eZ5xIDP8NCiziL2zMdMf+SKrWjCmW5sH0h/UXIO/7dPOd6lBha1DLwOtL7eyX
	 XO/0/hR0vTlB3Wy1EMkalsvYdgcCVkytWvZVH+M5Hy5A7kkwaYyQBbstRKVQA52SCO
	 m2z8obqhaLuipTWQLpyx/vAgcDsLnqjcVfp8NTY10sSr1R9qs/HMiXIgWMGpARHEoD
	 XJaBPaUCr4Blg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722EECA5FDD;
	Fri,  2 Oct 2026 15:01:29 +0000 (UTC)
From: Miguel Garcia via B4 Relay <devnull+miguelgarciaroman8.gmail.com@kernel.org>
Date: Fri, 02 Oct 2026 17:00:58 +0200
Subject: [PATCH v3] wifi: mwifiex: replace deprecated strcpy() with
 strscpy()
To: Brian Norris <briannorris@chromium.org>
Cc: Francesco Dolcini <francesco@dolcini.it>, 
 linux-wireless@vger.kernel.org, 
 Miguel Garcia <miguelgarciaroman8@gmail.com>
Message-ID: <179095325825.1998848.2691205243435840007.mwifiex-strscpy-v3@gmail.com>
X-Mailer: b4 0.13.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790953258; l=3986;
 i=miguelgarciaroman8@gmail.com; s=default; h=from:subject:message-id;
 bh=IVwajOKSRUqDnlhmPDEYuZeAEQwdQ6oxaUangjNedkw=;
 b=wOxWhwS9HYD3T3A7PwS6u0CV8Mf95VIxWy/iX1Dg7i0bq5WwhyY+lxCbcR/Iu/CuubGSHfDc/
 1BhfiLIS35sCVU5HkeQ//qi/A+SLQGjaoOkOTdiZfQSjaXrKu4vF/pz
X-Developer-Key: i=miguelgarciaroman8@gmail.com; a=ed25519;
 pk=EtrxRdQ/icT1qmJwjNNAVoBUhKKWwrhU2m6QT/xu6bM=
X-Endpoint-Received: by B4 Relay for miguelgarciaroman8@gmail.com/default
 with auth_id=1101
X-Original-From: Miguel Garcia <miguelgarciaroman8@gmail.com>
Reply-To: miguelgarciaroman8@gmail.com

From: Miguel Garcia <miguelgarciaroman8@gmail.com>

Replace the six strcpy() calls in mwifiex_pcie_get_fw_name() with
strscpy(), using sizeof(adapter->fw_name) as the destination size.

All six firmware names, including their terminating NUL bytes, fit in
the 32-byte array, so the selected firmware names remain unchanged.
Also simplify the function comment.

Assisted-by: LLM
Signed-off-by: Miguel Garcia <miguelgarciaroman8@gmail.com>
---
v3:
- New standalone thread, with no In-Reply-To. v2 was a reply and
  Patchwork stored it as a comment rather than as a patch.
- Subject prefix is "wifi: mwifiex:". v1 omitted "wifi:" and v2 used
  "wifi: pcie:".
- adapter->fw_name is a 32-byte array. v1 described it as 64 bytes.
- Keep the comment accepted by Brian Norris. Do not add a sentence
  about strscpy(), realign the version/magic masks, or insert the
  blank lines v2 added between cases.
- No Reviewed-by tag is carried forward from v1.

v1: https://lore.kernel.org/linux-wireless/20250705133600.186441-1-miguelgarciaroman8@gmail.com/
v2: https://lore.kernel.org/linux-wireless/20250723151718.367623-1-miguelgarciaroman8@gmail.com/
Brian Norris: https://lore.kernel.org/linux-wireless/aG1lcWYjk9GARp1P@google.com/
Johannes Berg: https://lore.kernel.org/linux-wireless/294d5e91279556b59586f0812eee4ac809d7b011.camel@sipsolutions.net/

AI assistance: Grok (xAI, grok-4.7) prepared this v3 from the reviewed
thread, edited these six call sites, and ran checkpatch.pl --strict,
git diff --check, git apply --check, and the targeted pcie.o build.
Codex reviewed the diff and refined the commit message. No device was tested.


 drivers/net/wireless/marvell/mwifiex/pcie.c | 22 ++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index a9425e9a94f4..7ad193841c2e 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3098,9 +3098,7 @@ static int mwifiex_pcie_request_irq(struct mwifiex_adapter *adapter)
 }
 
 /*
- * This function gets the firmware name for downloading by revision id
- *
- * Read revision id register to get revision id
+ * Get firmware name for download by revision ID
  */
 static void mwifiex_pcie_get_fw_name(struct mwifiex_adapter *adapter)
 {
@@ -3110,7 +3108,8 @@ static void mwifiex_pcie_get_fw_name(struct mwifiex_adapter *adapter)
 
 	switch (card->dev->device) {
 	case PCIE_DEVICE_ID_MARVELL_88W8766P:
-		strcpy(adapter->fw_name, PCIE8766_DEFAULT_FW_NAME);
+		strscpy(adapter->fw_name, PCIE8766_DEFAULT_FW_NAME,
+			sizeof(adapter->fw_name));
 		break;
 	case PCIE_DEVICE_ID_MARVELL_88W8897:
 		mwifiex_write_reg(adapter, 0x0c58, 0x80c00000);
@@ -3118,13 +3117,16 @@ static void mwifiex_pcie_get_fw_name(struct mwifiex_adapter *adapter)
 		revision_id &= 0xff00;
 		switch (revision_id) {
 		case PCIE8897_A0:
-			strcpy(adapter->fw_name, PCIE8897_A0_FW_NAME);
+			strscpy(adapter->fw_name, PCIE8897_A0_FW_NAME,
+				sizeof(adapter->fw_name));
 			break;
 		case PCIE8897_B0:
-			strcpy(adapter->fw_name, PCIE8897_B0_FW_NAME);
+			strscpy(adapter->fw_name, PCIE8897_B0_FW_NAME,
+				sizeof(adapter->fw_name));
 			break;
 		default:
-			strcpy(adapter->fw_name, PCIE8897_DEFAULT_FW_NAME);
+			strscpy(adapter->fw_name, PCIE8897_DEFAULT_FW_NAME,
+				sizeof(adapter->fw_name));
 
 			break;
 		}
@@ -3139,9 +3141,11 @@ static void mwifiex_pcie_get_fw_name(struct mwifiex_adapter *adapter)
 		if (revision_id == PCIE8997_A1 &&
 		    magic == CHIP_MAGIC_VALUE &&
 		    version == CHIP_VER_PCIEUART)
-			strcpy(adapter->fw_name, PCIEUART8997_FW_NAME_V4);
+			strscpy(adapter->fw_name, PCIEUART8997_FW_NAME_V4,
+				sizeof(adapter->fw_name));
 		else
-			strcpy(adapter->fw_name, PCIEUSB8997_FW_NAME_V4);
+			strscpy(adapter->fw_name, PCIEUSB8997_FW_NAME_V4,
+				sizeof(adapter->fw_name));
 		break;
 	default:
 		break;
-- 
2.43.0



