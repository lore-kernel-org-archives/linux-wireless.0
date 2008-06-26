Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n45.bullet.mail.ukl.yahoo.com ([87.248.110.178]:33246 "HELO
	n45.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932281AbYFZTjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 15:39:04 -0400
Message-ID: <4863F1DE.3080503@yahoo.co.uk> (sfid-20080626_213913_636136_D81B0AC3)
Date: Thu, 26 Jun 2008 20:45:34 +0100
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Matthew Garrett <mjg@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	herton@mandriva.com.br, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, andreamrl@tiscali.it, linville@redhat.com
Subject: Re: [RFC][PATCH] Realtek 8187B wireless support with product id	0x8197/0x8189
References: <779389.39286.qm@web23108.mail.ird.yahoo.com>	 <48630FE7.7060800@lwfinger.net> <4863D05A.7070801@yahoo.co.uk>	 <4863E113.1040609@lwfinger.net> <1214505894.18729.11.camel@dv>
In-Reply-To: <1214505894.18729.11.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Thu, 2008-06-26 at 13:33 -0500, Larry Finger wrote:
> 
>> Do I understand correctly that it might be better to check for the 
>> existence of endpoint 02 for an 8187 device? Or would it be better to 
>> look for endpoint 12 to set it as an 8187B?
> 
> It's probably OK either way, but I would look at some number that takes
> more than just 2 values (true and false).  Say, the number of endpoints
> would be such number.  This way, it there is some elusive 8187A or
> 8187C, it may have a different number and won't be mistaken for known
> chipsets.
> 
> Of course, we cannot guarantee anything.  It's just a matter of general
> sanity that may or may not help.  But sometimes it helps.

Larry's 8187 indeed looks like a 8187B i.e. the OEM being naughty and needs
some serious lashing there... where does it come from - what brand and what
is it bundled with?

The 8187/8187b code actually *uses* the
endpoints to send management frames for association - that's a functional 
difference and it is not possible to drive a 8187 as if it is a 8187b or
vice versa. In the absence of
more authoritative answers like reading from a register or something, counting
the endpoints - I would actually go a bit further and demand the used endpoints
being there and in the right direction and propertes (int/bulk) - would seem
to be a good idea. As for what to do "if things don't add up", at least a 
warning through dmesg "give the OEM some lashing for calling a 8187b 0x8187".

I think Larry's question could be re-phrased as: if there is a preculiar device
with *both* end point 2 and endpoint 12, what to treat it as?

I would be inclined to treat it as the newer chip - but some big warning, or
even refusing to carry on, is probably in order.

Herton's code also seem to distinguish revC/revD/revE of different 8187B's -
I don't seem to have seen those distinctions in the original vendor code, but
maybe I haven't look hard enough :-).

