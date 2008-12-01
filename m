Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:62511 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbYLAQRZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 11:17:25 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: Vivek Natarajan <vnatarajan@atheros.com>,
	linux-wireless@vger.kernel.org, Tomas Winkler <tomasw@gmail.com>
Subject: Re: [RFC] mac80211: Enhancements to dynamic power save.
References: <20081202011754.GA9382@myhost.users.atheros.com>
	<1228133121.3478.27.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 01 Dec 2008 18:17:10 +0200
In-Reply-To: <1228133121.3478.27.camel@johannes.berg> (ext Johannes Berg's message of "Mon\, 01 Dec 2008 13\:05\:21 +0100")
Message-ID: <873ah76fax.fsf@nokia.com> (sfid-20081201_171727_417620_CB3C8F8B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2008-12-01 at 17:17 -0800, Vivek Natarajan wrote:
>> This patch is based on Kalle's initial RFC patches on dynamic power save.
>> Since ath9k/ath5k,stlc45xx and b43 need the driver to send the null
>> frame, it is appropriate to do it from mac80211. 
>> This patch enables mac80211 to send a null frame and also to
>> check for tim in the beacon if power save is enabled.
>
> One thing I forgot, do we need a special iwlwifi flag to turn this off?
> Or can iwlwifi be programmed to let the host handle this (*), which
> might be beneficial for interoperability and uniformity purposes?

Having the null frame handling in firmware is faster and we might get
some power savings from that. But is the saving observable, that's an
another question :)

-- 
Kalle Valo
