Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:47004 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751865AbeC2VOe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 17:14:34 -0400
Received: by mail-qk0-f175.google.com with SMTP id o184so7415545qkd.13
        for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2018 14:14:33 -0700 (PDT)
Subject: Re: Passing uninitialised local variable
To: Himanshu Jha <himanshujha199640@gmail.com>,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com
References: <20180328112014.GA11484@himanshu-Vostro-3559>
Cc: kvalo@codeaurora.org, johannes.berg@intel.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5ABD5735.1050608@broadcom.com> (sfid-20180329_231442_526416_DCA5F429)
Date: Thu, 29 Mar 2018 23:14:29 +0200
MIME-Version: 1.0
In-Reply-To: <20180328112014.GA11484@himanshu-Vostro-3559>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/28/2018 1:20 PM, Himanshu Jha wrote:
> Hello everyone,

You added everyone, but me :-(

Not really a problem, but it would help if the driver name was mentioned 
in the subject.

> I recently found that a local variable in passed uninitialised to the
> function at
>
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:2950
>
>                  u32 var;
>                  err = brcmf_fil_iovar_int_get(ifp, "dtim_assoc", &var);
>                  if (err) {
>                          brcmf_err("wl dtim_assoc failed (%d)\n", err);
>                          goto update_bss_info_out;
>                  }
>                  dtim_period = (u8)var;
>
>
> Now, the brcmf_fil_iovar_int_get() is defined as:
>
> s32
> brcmf_fil_iovar_int_get(struct brcmf_if *ifp, char *name, u32 *data)
> {
>          __le32 data_le = cpu_to_le32(*data);
>          s32 err;
>
>          err = brcmf_fil_iovar_data_get(ifp, name, &data_le, sizeof(data_le));
>          if (err == 0)
>                  *data = le32_to_cpu(data_le);
>          return err;
> }
>
> We can cleary see that 'var' in used uninitialised in the very first line
> which is an undefined behavior.

Why undefined? We copy some stack data and we do transfer that to the 
device. However in this case the device does nothing with it and it is 
simply overwritten by the response.

> So, what could be a possible fix for the above ?
>
> I'm not sure initialising 'var' to 0 would be the correct solution.

Coverity flagged this and probably still does. For this particular 
instance setting var to '0' is fine. However, there are quite a few 
other places. For some instances the data contains a selector value for 
obtaining info from the device, which is what we copy in 
brcmf_fil_iovar_int_get(). So maybe it would be best to have a separate 
function for those, eg. brcmf_fil_iovar_int_selget() or so.

Regards,
Arend
