Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0070.outbound.protection.outlook.com ([104.47.37.70]:48800
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751098AbdFVAyN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 20:54:13 -0400
Subject: Re: cfg80211_ops
To: "Tobin C. Harding" <me@tobin.cc>, linux-wireless@vger.kernel.org
References: <20170622000347.GA15458@eros>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <a3105fed-a02b-cd0e-1f4a-e3f9a0b7dd1f@quantenna.com> (sfid-20170622_025419_012718_7F9D64F7)
Date: Wed, 21 Jun 2017 17:53:13 -0700
MIME-Version: 1.0
In-Reply-To: <20170622000347.GA15458@eros>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/21/2017 05:03 PM, Tobin C. Harding wrote:
> 
> Hi,
> 
> Is some one able to please confirm for me that the following
> cfg80211_ops callbacks are enough to implement a minimal functioning
> Wi-Fi driver. Assume that a virtual interface is added during driver
> initialization.
> 
> scan
> add_key
> get_key
> del_key
> sat_default_key
> connect
> disconnect
> set_wiphy_params

Hi, is this for STA-only? I guess you also need
mgmt_frame_register
mgmt_tx

and you don't need *_key callbacks in case its fine to operate without 
encryption.

> 
> thanks,
> Tobin
> 
