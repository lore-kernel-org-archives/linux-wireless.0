Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55723 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbXKMQWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 11:22:47 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 06/14] mac80211: adding 802.11n essential A-MSDURxcapability
Date: Tue, 13 Nov 2007 18:22:08 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB0403BC4E@hasmsx411.ger.corp.intel.com> (sfid-20071113_162252_802646_8019B9A7)
In-Reply-To: <1194885942.5229.62.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	<flamingice@sourmilk.net>, "Jouni Malinen" <j@w1.fi>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> I agree. Good point and thanks for the catch.
>> Would appreciate your opinion for next possible solution:
>> I'll Move ieee80211_rx_h_data_agg before ieee80211_rx_h_802_1x_pae,
and
>> assuming I identify A-MSDU, I'll loop for each internal MSDU on:
>>   ieee80211_rx_h_802_1x_pae 
>>   ieee80211_rx_h_drop_unencrypted
>>   ieee80211_rx_h_data
>> return value of ieee80211_rx_h_data_agg to
>> __ieee80211_invoke_rx_handlers will be this small loop's return value


> I'm not sure I'd like to see such a thing. One thing I'm generally
> unhappy with here is how the handlers are in a list but there isn't a
> point in adding/removing any. Also, I'm not convinced that what you're
> saying will actually work because the handlers expect 802.11 frames so
> you'd have to make 802.11 frames out of the 802.3 frames you get...

True, it is a drawback, as I'll have to create 802.11 frames instead of
802.3 (with important data duplicated into all of them), but then I'll
just call  ieee80211_invoke_rx_handlers with ieee80211_rx_handler
pointed to
local->rx_handlers[ieee80211_rx_h_802_1x_pae]. Then I won't have to
change any existing handler except of my new ieee80211_rx_h_amsdu
Do you think this approach makes sense?

> What I originally wanted to do for this was to add a new
> "handle_data_frame" function that operates on 802.3 frames but has all
> the info available, is called from the rx_h_data handler and

> incorporates all the three callbacks you list above.That'd be similar
to
> what I did with the crypto code (where we now only have a single
handler

Do you mean ieee80211_rx_h_decrypt? 
If yes, I see it uses 3 different decrypt schemes. Here I have one
scheme reaping it self over and over.

> doing it all rather than a bunch doing different pieces of the
> functionality)
>
> It'd basically look like this
>
> handle_data_frame
> {
>	result = handle_pae()
>	if (result == ...)
>
>	if (should_drop_unencrypted && is_unencrypted())
>		return DROP
>
>	...
> }
>
> and rx_h_data would simply reframe the frame and pass it to this
> function, and your deaggregation handler would loop over this
function.
>
> You should be able to do this in the code right now because I removed
> the management interface and hence EAPOL frames aren't handled
> specially. Hostapd wants to have eapol frames on the management
> interface and 802.11 framed, but I don't understand that and would
> rather have it be done differently.
>
> We may need more discussion, but I believe finding a good solution to
> this is a crucial part of proper support for deaggregation.

> johannes
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
