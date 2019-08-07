Return-Path: <SRS0=5ylD=WD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E34EC41514
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Aug 2019 09:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2C0922305
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Aug 2019 09:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387476AbfHGJSM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Aug 2019 05:18:12 -0400
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:55584 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727987AbfHGJSL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Aug 2019 05:18:11 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id EFB30180A76DC;
        Wed,  7 Aug 2019 09:18:09 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: joke88_46ef5e8f7f662
X-Filterd-Recvd-Size: 3395
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Wed,  7 Aug 2019 09:18:07 +0000 (UTC)
Message-ID: <e8054867214be2e12f1bbf2c21b62ac041b6cccb.camel@perches.com>
Subject: Re: [PATCH -next] iwlwifi: dbg: work around clang bug by marking
 debug strings static
From:   Joe Perches <joe@perches.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kalle Valo <kvalo@codeaurora.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Date:   Wed, 07 Aug 2019 02:18:06 -0700
In-Reply-To: <20190807051516.GA117639@archlinux-threadripper>
References: <20190712001708.170259-1-ndesaulniers@google.com>
         <874l31r88y.fsf@concordia.ellerman.id.au>
         <3a2b6d4f9356d54ab8e83fbf25ba9c5f50181f0d.camel@sipsolutions.net>
         <CAKwvOdmBeB1BezsGh=cK=U9m8goKzZnngDRzNM7B1voZfh8yWg@mail.gmail.com>
         <20190807051516.GA117639@archlinux-threadripper>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-08-06 at 22:15 -0700, Nathan Chancellor wrote:
> Just for everyone else (since I commented on our issue tracker), this is
> now fixed in Linus's tree as of commit  1f6607250331 ("iwlwifi: dbg_ini:
> fix compile time assert build errors").

I think this change is incomplete and suggest you add this
to remove the use of another const char * format.

---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 4d81776f576d..6b15e2e8cd37 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2593,20 +2593,20 @@ static void iwl_fw_dbg_update_regions(struct iwl_fw_runtime *fwrt,
 {
 	void *iter = (void *)tlv->region_config;
 	int i, size = le32_to_cpu(tlv->num_regions);
-	const char *err_st =
-		"WRT: ext=%d. Invalid region %s %d for apply point %d\n";
 
 	for (i = 0; i < size; i++) {
 		struct iwl_fw_ini_region_cfg *reg = iter, **active;
 		int id = le32_to_cpu(reg->region_id);
 		u32 type = le32_to_cpu(reg->region_type);
 
-		if (WARN(id >= ARRAY_SIZE(fwrt->dump.active_regs), err_st, ext,
-			 "id", id, pnt))
+		if (WARN(id >= ARRAY_SIZE(fwrt->dump.active_regs),
+			 "WRT: ext=%d. Invalid region id %d for apply point %d\n",
+			 ext, id, pnt))
 			break;
 
-		if (WARN(type == 0 || type >= IWL_FW_INI_REGION_NUM, err_st,
-			 ext, "type", type, pnt))
+		if (WARN(type == 0 || type >= IWL_FW_INI_REGION_NUM,
+			 "WRT: ext=%d. Invalid region type %d for apply point %d\n",
+			 ext, type, pnt))
 			break;
 
 		active = &fwrt->dump.active_regs[id];


