Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:30761 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbYKSMdj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 07:33:39 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2823467fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2008 04:33:37 -0800 (PST)
Message-ID: <8e92b4100811190433l24ab5043nd4e14ff7c7124e20@mail.gmail.com> (sfid-20081119_133343_724264_B8DE80A4)
Date: Wed, 19 Nov 2008 18:03:37 +0530
From: "Vivek Natarajan" <vivek.natraj@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Look out for some other AP when disassoc is received.
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com
In-Reply-To: <1227095716.26243.20.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081120000322.GA2828@myhost.users.atheros.com>
	 <1227095716.26243.20.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 19, 2008 at 5:25 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-11-19 at 16:03 -0800, Vivek Natarajan wrote:
>> When a disassoc packet is received with a reason code of 'AP leaving the BSS',
>> mac80211 should start looking for some other AP instead of trying to
>> associate with the same AP.
>
> Umm, it doesn't try to associated with the same AP. And the patch you're
> doing is kinda pointless, the reason codes are very often simply wrong
> or "due to some local policy decision".

Here is the test scenario that exposed this issue:
* There are two APs with the same SSID so that the sta can roam if one is down.
* When the AP to which the station is connected is brought down or restarted,
  it sends( should send according to 802.11 spec) a disassoc frame with a
  reason code of 8 which means the sender is leaving the BSS.
* After receiving a disassoc, mac80211 moves to ASSOCIATE state in
which scanning
   is disabled. So, for the first scan request from
wpa_supplicant(scan duration of 30sec),
   it tries to send probe   request to the same AP instead of scanning
for other APs.
   Then it moves to DISABLED  state since there will be no probe response.
* The next scan request comes only after 30sec and now it will scan
for all available APs
   since scanning  is supported in DISABLED state.
    So, it takes atleast 30sec to connect to some other AP.

> Also, the reason code that's being passed is the one we send ourselves,
> not the one we received.

I have passed the reason code from ieee80211_rx_mgmt_disassoc which is called
only after we receive a disassoc frame from the AP.

--
Vivek.
