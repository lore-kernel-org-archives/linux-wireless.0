Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39780 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaJNKBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 06:01:40 -0400
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] cfg80211: Specify frame and reason code for
 NL80211_CMD_DEL_STATION
Date: Tue, 14 Oct 2014 10:01:38 +0000
Message-ID: <D062B86A.43EB2%jouni@qca.qualcomm.com> (sfid-20141014_120153_823405_4AFF5FAA)
References: <20141010175525.GA29436@jouni.qca.qualcomm.com>
 <1413278472.2455.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1413278472.2455.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 14/10/14 11:21 am, "Johannes Berg" <johannes@sipsolutions.net> wrote:

>On Fri, 2014-10-10 at 20:55 +0300, Jouni Malinen wrote:
>
>>+ * @reason_code: Reason code for the Disassociation/Deauthentication
>>frame
>>   */
>>  struct station_del_parameters {
>>  	const u8 *mac;
>> +	u8 subtype;
>> +	u16 reason_code;
>
>the reason_code could end up being zero right now, if userspace doesn't
>specify the attribute.

That was more or less by design, but not really fully documented and not
really supposed to be used if the subtype is not provided.

>I think you should probably force a reason code to be given when
>specifying the subtype. And I'm thinking that defaulting to deauth/3
>would be better than leaving it up to the driver(s)?

I guess we could do that in cfg80211. I was trying to follow the current
behavior for this (i.e., not telling the driver what to do if user space
does not require something). As an example, ath6kl uses Deauthentication
with reason code 2. I don't think reason code 3 would be a good default,
though, since it has a special meaning for P2P groups (GO indicates group
is being terminated). That specific use case is one of the main reasons
for making sure that user space can specify that Deauthentication with a
specific reason code is used.

I think I would be fine with cfg80211 default being Deauthentication frame
with reason code 2, so if that is what you would like to see here (rather
than leaving this to the drivers), I can update the patch to behave in
that way.

- Jouni

