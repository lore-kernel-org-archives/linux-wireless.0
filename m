Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:44452 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752853AbeC1LUY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 07:20:24 -0400
Date: Wed, 28 Mar 2018 16:50:14 +0530
From: Himanshu Jha <himanshujha199640@gmail.com>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com
Cc: kvalo@codeaurora.org, johannes.berg@intel.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: Passing uninitialised local variable
Message-ID: <20180328112014.GA11484@himanshu-Vostro-3559> (sfid-20180328_132033_984311_221AF2AC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone,


I recently found that a local variable in passed uninitialised to the
function at 

drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:2950

                u32 var; 
                err = brcmf_fil_iovar_int_get(ifp, "dtim_assoc", &var);
                if (err) {
                        brcmf_err("wl dtim_assoc failed (%d)\n", err);
                        goto update_bss_info_out;
                }
                dtim_period = (u8)var;


Now, the brcmf_fil_iovar_int_get() is defined as:

s32
brcmf_fil_iovar_int_get(struct brcmf_if *ifp, char *name, u32 *data)
{
        __le32 data_le = cpu_to_le32(*data);
        s32 err;

        err = brcmf_fil_iovar_data_get(ifp, name, &data_le, sizeof(data_le));
        if (err == 0)
                *data = le32_to_cpu(data_le);
        return err;
}

We can cleary see that 'var' in used uninitialised in the very first line
which is an undefined behavior.

So, what could be a possible fix for the above ?

I'm not sure initialising 'var' to 0 would be the correct solution.

-- 
Thanks
Himanshu Jha
