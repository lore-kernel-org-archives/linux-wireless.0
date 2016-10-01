Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60417 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750951AbcJAMQL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Oct 2016 08:16:11 -0400
Date: Sat, 1 Oct 2016 13:56:22 +0200
From: Greg KH <greg@kroah.com>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        Larry.Finger@lwfinger.net, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] rtl8xxxu: Fix rtl8723bu driver reload issue
Message-ID: <20161001115622.GB15156@kroah.com> (sfid-20161001_141647_476819_650A0A8F)
References: <1475278518-18527-1-git-send-email-Jes.Sorensen@redhat.com>
 <1475278518-18527-2-git-send-email-Jes.Sorensen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1475278518-18527-2-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 30, 2016 at 07:35:17PM -0400, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> The generic disable_rf() function clears bits 22 and 23 in
> REG_RX_WAIT_CCA, however we did not re-enable them again in
> rtl8723b_enable_rf()
> 
> This resolves the problem for me with 8723bu devices not working again
> after reloading the driver.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 4 ++++
>  1 file changed, 4 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
