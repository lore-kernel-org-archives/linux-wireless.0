Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 19.mo7.mail-out.ovh.net ([178.33.251.118]:48438 "EHLO
        19.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753021AbdBPJju (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 04:39:50 -0500
Received: from player694.ha.ovh.net (b7.ovh.net [213.186.33.57])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id C0BA941F49
        for <linux-wireless@vger.kernel.org>; Thu, 16 Feb 2017 10:39:48 +0100 (CET)
Subject: Re: drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:58:6:
 error: redefinition of 'brcmf_debugfs_init'
To: Kalle Valo <kvalo@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
References: <201702071839.Ej9MjmlI%fengguang.wu@intel.com>
 <ce7467a9-12d5-f64e-8b59-f9581db9f7c8@infradead.org>
 <87inoamqh6.fsf@kamboji.qca.qualcomm.com>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Message-ID: <e8c43505-1e7a-635c-dc27-45422acb25a6@milecki.pl> (sfid-20170216_103955_399326_8D875BAA)
Date: Thu, 16 Feb 2017 10:39:40 +0100
MIME-Version: 1.0
In-Reply-To: <87inoamqh6.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/16/2017 10:31 AM, Kalle Valo wrote:
> (Adding linux-wireless)
>
> Randy Dunlap <rdunlap@infradead.org> writes:
>
>> On 02/07/17 02:02, kbuild test robot wrote:
>>> Hi Kalle,
>>>
>>> FYI, the error/warning still remains.
>>>
>>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>>> head:   8b1b41ee74f9712c355d66dc105bbea663ae0afd
>>> commit: 05491d2ccf20b20a1375303441fbbfbd12b24a4f brcm80211: move
>>> under broadcom vendor directory
>>> date:   1 year, 3 months ago
>>> config: mips-allyesconfig (attached as .config)
>>> compiler: mips-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
>>> reproduce:
>>>         wget
>>> https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross
>>> -O ~/bin/make.cross
>>>         chmod +x ~/bin/make.cross
>>>         git checkout 05491d2ccf20b20a1375303441fbbfbd12b24a4f
>>>         # save the attached .config to linux build tree
>>>         make.cross ARCH=mips
>>>
>>> All errors (new ones prefixed by >>):
>>
>> when both:
>>
>> CONFIG_BRCM_TRACING=y
>> CONFIG_BRCMDBG=y
>>
>> but DEBUG is not defined.
>>
>> I think it would help if CONFIG_BRCMDBG set DEBUG
>> or if some of the tests for DEBUG used CONFIG_BRCMDBG instead.
>
> Arend or Rafał, would you be able to look at this build problem? Kbuild
> found the build errors below, apparently a very old issue. It just
> blames me now because I moved the driver to a new directory :)

Something like this maybe? Note I didn't test it with above config.

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 6687812770cc..8c7695fde482 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -108,7 +108,7 @@ do {									\
  extern int brcmf_msg_level;

  struct brcmf_pub;
-#ifdef DEBUG
+#ifdef CONFIG_BRCMDBG
  void brcmf_debugfs_init(void);
  void brcmf_debugfs_exit(void);
  int brcmf_debug_attach(struct brcmf_pub *drvr);
