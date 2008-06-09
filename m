Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:3855 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758949AbYFIKBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 06:01:24 -0400
Received: by rv-out-0506.google.com with SMTP id k40so225450rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 03:01:24 -0700 (PDT)
Message-ID: <1ba2fa240806090301h2a1a3350x606cfe1d83be066a@mail.gmail.com> (sfid-20080609_120132_835879_2F0B2A83)
Date: Mon, 9 Jun 2008 13:01:24 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH 3/7] mac80211: add utility function to get header length
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213002964.698.67.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1212774672.6340.77.camel@brick>
	 <1213002964.698.67.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 9, 2008 at 12:16 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>>  /**
>> + * ieee80211_hdrlen - get header length in bytes from frame control
>> + * @fc: frame control field in little-endian format
>> + */
>> +unsigned int ieee80211_hdrlen(__le16 fc);
>> +
>
>> +EXPORT_SYMBOL(ieee80211_hdrlen);
>
> Do we really need to export that?

so now we have hdrlen(u16) and hdrlen(__le16)  it will be fun.

So I guess will we converting idioms
u16 fc = le16_to_cpu(hdr->frame_control);
int hdr_len = ieee80211_get_hdrlen(fc);
to
int hdr_len = ieee80211_hdrlen(hdr->frame_control)

This is how it used in driver code so it make sense to export this
function and remove ieee80211_get_hdrlen(fc)

Since all fc operations are bitwise 'and' and 'or'
u16 rx->fc can be dropped in future as well

Tomas
