Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:51411 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbbA2Wzd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 17:55:33 -0500
Received: by mail-lb0-f181.google.com with SMTP id u10so33481667lbd.12
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jan 2015 14:55:32 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 29 Jan 2015 23:55:31 +0100
Message-ID: <CACna6rykYmq6ucTHJ40vcySOFYs3qeim_ZOpNQsNGzyFo=w-aQ@mail.gmail.com> (sfid-20150129_235536_584438_19DB3CC6)
Subject: cfg80211_ops: deauthentication & disassociation
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm looking at deauthentication & disassociation with cfg80211 API.
AFAIK both frames can be send by STA as well as AP (according to the
standard). I was looking info few cfg80211 callbacks and have few
questions.

1) @disassoc
I think it's just for disassociating from AP. Is that correct?

2) @del_station
Now, this gets tricky for me. I think this callback is for AP mode to
deauthenticae/disassociate a STA. It seems hostapd follows the same
idea as in driver_nl80211.c it uses NL80211_CMD_DEL_STATION for both:
deauth and disassoc (without building own frame).

So I started analyzing this with the base case: mac80211
(ieee80211_del_station). I expected to find a place where mac80211
constructs deauth/disassoc management frame and transmits it. But I
really couldn't. It seems that all ieee80211_del_station does is
calling __sta_info_destroy / __sta_info_destroy_part1 /
__sta_info_destroy_part2.
Did I miss something? Or does mac80211 really ignore sending proper
management frames in this case?

On the other hand cfg80211 drivers seem to be doing something more in
the @del_station callback. E.g.:
a) wil6210 seems to be sending some frame:
wmi_send(wil, WMI_DISCONNECT_STA_CMDID, &cmd, sizeof(cmd));
b) brcmfmac does as well:
brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON,
&scbval, sizeof(scbval));
c) mwifiex as well:
mwifiex_send_cmd(priv, HostCmd_CMD_UAP_STA_DEAUTH, ...);


Can you help to understand this, please? Is @del_station handler
supposed to actually send a proper management frame?

-- 
Rafał
