Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:43738 "EHLO
	viefep24-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752883AbYIOQBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 12:01:14 -0400
Received: from gollum.odi.ch ([84.74.148.76]) by viefep24-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20080915160055.GHRY891.viefep24-int.chello.at@gollum.odi.ch>
          for <linux-wireless@vger.kernel.org>;
          Mon, 15 Sep 2008 18:00:55 +0200
Received: from [192.168.111.10] (mithril [192.168.111.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by gollum.odi.ch (Postfix) with ESMTPSA id AD77F3BE6
	for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 18:00:54 +0200 (CEST)
Message-ID: <48CE86B6.6080704@odi.ch> (sfid-20080915_180118_027162_C9C60EF5)
Date: Mon, 15 Sep 2008 18:00:54 +0200
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] Don't destroy authentication algorithm before	authenticating.
References: <48CE8452.9080604@odi.ch> (sfid-20080915_175050_484202_3CD78757) <1221494039.3700.47.camel@johannes.berg>
In-Reply-To: <1221494039.3700.47.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Johannes Berg wrote:
> On Mon, 2008-09-15 at 17:50 +0200, Ortwin Gl=C3=BCck wrote:
>> reset_auth is called before each authentication try. So it should no=
t destroy
>> the auth_alg that was set before.
>>
>> NB: this may have side-effects with automatic algorithm selection if=
 AP responds=20
>> with alg not supported.
>=20
> This seems entirely wrong.
>=20
> Is your AP not capable of/configured to do open auth and _also_ doesn=
't
> reject the attempt? That is, the AP is just completely broken?

Well, I see that with other (binary) drivers it actively rejects such=20
authentication attempts. But with this driver it doesnt. The only diffe=
rence=20
that I can see from the packet logs is that mac80211 sends no probes be=
fore the=20
authentication, and that the sequence number is being reset. So maybe t=
hat keeps=20
this Netgear AP (yes it's crap) from rejecting. Or then it's something =
in ath9k=20
that causes the AP not to receive the packets in the first place.

Ortwin

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
