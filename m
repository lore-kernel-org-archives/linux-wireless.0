Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54181 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933241AbdA0RvI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 12:51:08 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,02/13] wil6210: add disable_ap_sme module parameter
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1484226365-10433-3-git-send-email-qca_merez@qca.qualcomm.com>
References: <1484226365-10433-3-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Dedy Lansky <qca_dlansky@qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>
Message-ID: <ac37937bc2304d6197e6112c325d1bc5@eusanexr01a.eu.qualcomm.com> (sfid-20170127_185411_536879_3664584D)
Date: Fri, 27 Jan 2017 09:50:52 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:
> From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
> 
> By default, AP SME is handled by driver/FW.
> In case disable_ap_sme is true, driver doesn't turn-on
> WIPHY_FLAG_HAVE_AP_SME and the responsibility for
> AP SME is passed to user space.
> 
> With AP SME disabled, driver reports assoc request frame
> to user space which is then responsible for sending assoc
> response frame and for sending NL80211_CMD_NEW_STATION.
> Driver also reports disassoc frame to user space
> which should then send NL80211_CMD_DEL_STATION.
> 
> NL80211_CMD_SET_STATION with NL80211_STA_FLAG_AUTHORIZED
> is used by user space to allow/disallow data transmit.
> 
> Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>

11 patches applied to ath-next branch of ath.git, thanks.

849a564b7e28 wil6210: add disable_ap_sme module parameter
a351f2f537b7 wil6210: support loading dedicated image for sparrow-plus devices
af3db60a3033 wil6210: remove __func__ from debug printouts
0d2370e939ac wil6210: support new WMI-only FW capability
4d4c4dc324b4 wil6210: missing reinit_completion in wmi_call
3ee908dc3b48 wil6210: protect against false interrupt during reset sequence
a895cb8b990c wil6210: fix for broadcast workaround in PBSS
a52fb913aee9 wil6210: align to latest auto generated wmi.h
9d865ee232ec wil6210: report association ID (AID) per station in debugfs
c3bfea05a6fd wil6210: option to override A-BFT length in start AP/PCP
78484c44e4b3 wil6210: convert symbolic permissions to octal permissions

-- 
https://patchwork.kernel.org/patch/9513175/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
