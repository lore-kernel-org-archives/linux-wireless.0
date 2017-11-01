Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0081.outbound.protection.outlook.com ([104.47.33.81]:46056
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932210AbdKACbl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 22:31:41 -0400
Subject: Re: [PATCH] mac80211: Update last_ack status for all except probing
 frames
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
References: <1509409746-26592-1-git-send-email-rmanohar@qti.qualcomm.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <46362ff1-acfb-701c-5f71-7d117d223e1a@quantenna.com> (sfid-20171101_033146_493487_6EFC96E2)
Date: Tue, 31 Oct 2017 19:31:33 -0700
MIME-Version: 1.0
In-Reply-To: <1509409746-26592-1-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/30/2017 05:29 PM, Rajkumar Manoharan wrote:
> 
> Update last_ack status for all except station probing frames
> (i.e null data). Otherwise the station inactivity duration is
> cleared whenever AP is checking presence of idle stations by sending
> null data frame for every inactive threshold (ap_max_inactivity).
> Though the station is idle for longer period, the inactive
> time in station dump is restricted ap_max_inactivity threshold.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---

To clarify: wouldn't it break hostapd's "inactivity timeot kick-out" 
logic in hostapd? As hostapd generates NULL frames to idle stations to 
reset their inactivity time, otherwise it will disassociate a station, 
after an ap_max_inactivity period.
