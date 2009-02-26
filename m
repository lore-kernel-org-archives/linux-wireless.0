Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:30688 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbZBZX24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 18:28:56 -0500
MIME-Version: 1.0
In-Reply-To: <49A7236E.2020807@gmail.com>
References: <1235688271-22346-1-git-send-email-jirislaby@gmail.com>
	 <20090226230338.M86894@bobcopeland.com> <49A7236E.2020807@gmail.com>
Date: Thu, 26 Feb 2009 18:28:54 -0500
Message-ID: <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com> (sfid-20090227_002902_948751_7015C35B)
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
From: Bob Copeland <me@bobcopeland.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 26, 2009 at 6:19 PM, Jiri Slaby <jirislaby@gmail.com> wrote=
:
> On 27.2.2009 00:15, Bob Copeland wrote:
>> Speaking of, I think there's another potential oob array access at:
>>
>> if (rxs.rate_idx>=3D 0&& =A0rs.rs_rate =3D=3D
>> =A0 =A0 =A0sc->curband->bitrates[rxs.rate_idx].hw_value_short)
>> =A0 =A0 =A0 =A0 =A0rxs.flag |=3D RX_FLAG_SHORTPRE;
>>
>> because sc->rate_idx is u8 instead of s8.
>
> strcmp("sc->rate_idx", "rxs.rate_idx") !=3D 0 :)
>
> Or did I miss something?

:)  Sorry, I should've been clearer.

hw_to_driver_rix() returns sc->rate_idx[x][y] as an int, and that
array is initialized to (u8)-1 for invalid rates.  So, it can
return 255 if the hardware rate index (y) is bad, then the check
"rxs.rate_idx >=3D 0" would always be true, right?  If it's not a
real bug yet, it likely will be one day :)

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
