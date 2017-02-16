Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41292 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752649AbdBPJbu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 04:31:50 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Randy Dunlap <rdunlap@infradead.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:58:6: error: redefinition of 'brcmf_debugfs_init'
References: <201702071839.Ej9MjmlI%fengguang.wu@intel.com>
        <ce7467a9-12d5-f64e-8b59-f9581db9f7c8@infradead.org>
Date: Thu, 16 Feb 2017 11:31:33 +0200
In-Reply-To: <ce7467a9-12d5-f64e-8b59-f9581db9f7c8@infradead.org> (Randy
        Dunlap's message of "Tue, 7 Feb 2017 08:31:39 -0800")
Message-ID: <87inoamqh6.fsf@kamboji.qca.qualcomm.com> (sfid-20170216_103217_219510_1A988D33)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Adding linux-wireless)

Randy Dunlap <rdunlap@infradead.org> writes:

> On 02/07/17 02:02, kbuild test robot wrote:
>> Hi Kalle,
>>=20
>> FYI, the error/warning still remains.
>>=20
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.g=
it master
>> head:   8b1b41ee74f9712c355d66dc105bbea663ae0afd
>> commit: 05491d2ccf20b20a1375303441fbbfbd12b24a4f brcm80211: move
>> under broadcom vendor directory
>> date:   1 year, 3 months ago
>> config: mips-allyesconfig (attached as .config)
>> compiler: mips-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
>> reproduce:
>>         wget
>> https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbi=
n/make.cross
>> -O ~/bin/make.cross
>>         chmod +x ~/bin/make.cross
>>         git checkout 05491d2ccf20b20a1375303441fbbfbd12b24a4f
>>         # save the attached .config to linux build tree
>>         make.cross ARCH=3Dmips=20
>>=20
>> All errors (new ones prefixed by >>):
>
> when both:
>
> CONFIG_BRCM_TRACING=3Dy
> CONFIG_BRCMDBG=3Dy
>
> but DEBUG is not defined.
>
> I think it would help if CONFIG_BRCMDBG set DEBUG
> or if some of the tests for DEBUG used CONFIG_BRCMDBG instead.

Arend or Rafa=C5=82, would you be able to look at this build problem? Kbuild
found the build errors below, apparently a very old issue. It just
blames me now because I moved the driver to a new directory :)

>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:58:6:
>> error: redefinition of 'brcmf_debugfs_init'
    void brcmf_debugfs_init(void)
         ^~~~~~~~~~~~~~~~~~
   In file included from drivers/net/wireless/broadcom/brcm80211/brcmfmac/b=
us.h:20:0,
                    from drivers/net/wireless/broadcom/brcm80211/brcmfmac/d=
ebug.c:24:
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h:118:20: note: p=
revious definition of 'brcmf_debugfs_init' was here
    static inline void brcmf_debugfs_init(void)
                       ^~~~~~~~~~~~~~~~~~
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:65:6:
>> error: redefinition of 'brcmf_debugfs_exit'
    void brcmf_debugfs_exit(void)
         ^~~~~~~~~~~~~~~~~~
   In file included from drivers/net/wireless/broadcom/brcm80211/brcmfmac/b=
us.h:20:0,
                    from drivers/net/wireless/broadcom/brcm80211/brcmfmac/d=
ebug.c:24:
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h:121:20: note: p=
revious definition of 'brcmf_debugfs_exit' was here
    static inline void brcmf_debugfs_exit(void)
                       ^~~~~~~~~~~~~~~~~~
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:74:5:
>> error: redefinition of 'brcmf_debug_attach'
    int brcmf_debug_attach(struct brcmf_pub *drvr)
        ^~~~~~~~~~~~~~~~~~
   In file included from drivers/net/wireless/broadcom/brcm80211/brcmfmac/b=
us.h:20:0,
                    from drivers/net/wireless/broadcom/brcm80211/brcmfmac/d=
ebug.c:24:
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h:124:19: note: p=
revious definition of 'brcmf_debug_attach' was here
    static inline int brcmf_debug_attach(struct brcmf_pub *drvr)
                      ^~~~~~~~~~~~~~~~~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c: In function 'b=
rcmf_debug_attach':
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:81:6:
>> error: 'struct brcmf_pub' has no member named 'dbgfs_dir'
     drvr->dbgfs_dir =3D debugfs_create_dir(dev_name(dev), root_folder);
         ^~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:82:17: error: '=
struct brcmf_pub' has no member named 'dbgfs_dir'
     if (IS_ERR(drvr->dbgfs_dir))
                    ^~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:83:22: error: '=
struct brcmf_pub' has no member named 'dbgfs_dir'
      return PTR_ERR(drvr->dbgfs_dir);
                         ^~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c: At top level:
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:90:6:
>> error: redefinition of 'brcmf_debug_detach'
    void brcmf_debug_detach(struct brcmf_pub *drvr)
         ^~~~~~~~~~~~~~~~~~
   In file included from drivers/net/wireless/broadcom/brcm80211/brcmfmac/b=
us.h:20:0,
                    from drivers/net/wireless/broadcom/brcm80211/brcmfmac/d=
ebug.c:24:
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h:128:20: note: p=
revious definition of 'brcmf_debug_detach' was here
    static inline void brcmf_debug_detach(struct brcmf_pub *drvr)
                       ^~~~~~~~~~~~~~~~~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c: In function 'b=
rcmf_debug_detach':
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:94:26: error: '=
struct brcmf_pub' has no member named 'dbgfs_dir'
     if (!IS_ERR_OR_NULL(drvr->dbgfs_dir))
                             ^~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:95:32: error: '=
struct brcmf_pub' has no member named 'dbgfs_dir'
      debugfs_remove_recursive(drvr->dbgfs_dir);
                                   ^~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c: In function 'b=
rcmf_debugfs_get_devdir':
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:100:13: error: =
'struct brcmf_pub' has no member named 'dbgfs_dir'
     return drvr->dbgfs_dir;
                ^~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c: At top level:
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:103:5:
>> error: redefinition of 'brcmf_debugfs_add_entry'
    int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
        ^~~~~~~~~~~~~~~~~~~~~~~
   In file included from drivers/net/wireless/broadcom/brcm80211/brcmfmac/b=
us.h:20:0,
                    from drivers/net/wireless/broadcom/brcm80211/brcmfmac/d=
ebug.c:24:
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h:132:5: note: pr=
evious definition of 'brcmf_debugfs_add_entry' was here
    int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
        ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c: In function 'b=
rcmf_debugfs_add_entry':
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:109:10: error: =
'struct brcmf_pub' has no member named 'dbgfs_dir'
         drvr->dbgfs_dir, read_fn);
             ^~
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c: In function 'b=
rcmf_debugfs_get_devdir':
   drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:101:1: warning:=
 control reaches end of non-void function [-Wreturn-type]
    }
    ^


--=20
Kalle Valo
