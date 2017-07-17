Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:32887 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdGQVbo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 17:31:44 -0400
Received: by mail-wr0-f176.google.com with SMTP id a10so1856701wrd.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 14:31:43 -0700 (PDT)
Subject: Re: BUG: brcmfmac: add firmware feature detection for gscan feature
 breaks 43430a1
To: Ian Molton <ian@mnementh.co.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
References: <25c47ffe-af3e-fb85-ed5b-ff1987cfd93f@mnementh.co.uk>
 <e6635794-7c35-1a46-2d5b-68824c7b0657@mnementh.co.uk>
 <ff344ee3-3feb-6886-8007-d8ed00386424@broadcom.com>
 <c322c7c6-823b-0d36-8968-101d143b3220@mnementh.co.uk>
 <6c512250-5299-0cad-675b-e7780e999b58@broadcom.com>
 <246dc2f3-5cfd-7e89-6244-50fa2f546306@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0271ee86-ba99-fc50-46cd-b796f614fa19@broadcom.com> (sfid-20170717_233148_297468_582FEA2C)
Date: Mon, 17 Jul 2017 23:31:41 +0200
MIME-Version: 1.0
In-Reply-To: <246dc2f3-5cfd-7e89-6244-50fa2f546306@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 17-07-17 22:41, Ian Molton wrote:
> On 17/07/17 21:36, Arend van Spriel wrote:
> 
>> In <debugfs_mountpoint>/brcmfmac/*/forensics, but you have to load the
>> driver with modules parameter 'ignore_probe_fail=1' to avoid the driver
>> remove tearing down all debugfs stuff.
> 
> modinfo shows:
> 
> parm:           txglomsz:Maximum tx packet chain size [SDIO] (int)
> parm:           debug:Level of debug output (int)
> parm:           p2pon:Enable legacy p2p management functionality (int)
> parm:           feature_disable:Disable features (int)
> parm:           alternative_fw_path:Alternative firmware path (string)
> parm:           fcmode:Mode of firmware signalled flow control (int)
> parm:           roamoff:Do not use internal roaming engine (int)
> 

Seems you did not build with CONFIG_BRCMDBG?

common.c:

#ifdef DEBUG
/* always succeed brcmf_bus_started() */
static int brcmf_ignore_probe_fail;
module_param_named(ignore_probe_fail, brcmf_ignore_probe_fail, int, 0);
MODULE_PARM_DESC(ignore_probe_fail, "always succeed probe for debugging");
#endif

Regards,
Arend
