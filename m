Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38326 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751098AbdHNTW3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 15:22:29 -0400
Received: by mail-wm0-f54.google.com with SMTP id f15so548265wmg.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Aug 2017 12:22:28 -0700 (PDT)
Subject: Re: [PATCH] nl80211: add an option to allow MFP without requiring it
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Avinash Patil <avinashp@quantenna.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>
References: <20170814134911.20869-1-emmanuel.grumbach@intel.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a35aea64-b391-2719-c8cb-92ef9c9288c7@broadcom.com> (sfid-20170814_212232_879952_6490A186)
Date: Mon, 14 Aug 2017 21:22:25 +0200
MIME-Version: 1.0
In-Reply-To: <20170814134911.20869-1-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-08-17 15:49, Emmanuel Grumbach wrote:
> User space can now allow the kernel to associate to an AP
> that requires MFP or that doesn't have MFP enabled in the
> same NL80211_CMD_CONNECT command.
> The driver / firmware will decide whether to use it or not.
> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
> A short tour of the drivers taught me that only Quantenna really look
> at cfg80211_connect_params::sme which can now be 2. This is why
> the maintainer of this driver is CCed.

Indeed in brcmfmac the IE is processed to determine whether it is 
required or optional. Probably will change our driver to use the 
explicit mfp values from cfg80211_connect_params::sme.

Thanks,
Arend
