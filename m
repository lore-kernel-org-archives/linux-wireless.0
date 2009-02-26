Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:64149 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbZBZXdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 18:33:00 -0500
Message-ID: <49A726A7.6090809@gmail.com> (sfid-20090227_003305_059290_F90337E1)
Date: Fri, 27 Feb 2009 00:32:55 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
References: <1235688271-22346-1-git-send-email-jirislaby@gmail.com>	 <20090226230338.M86894@bobcopeland.com> <49A7236E.2020807@gmail.com> <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com>
In-Reply-To: <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27.2.2009 00:28, Bob Copeland wrote:
> hw_to_driver_rix() returns sc->rate_idx[x][y] as an int, and that
> array is initialized to (u8)-1 for invalid rates.  So, it can
> return 255 if the hardware rate index (y) is bad, then the check
> "rxs.rate_idx>= 0" would always be true, right?  If it's not a
> real bug yet, it likely will be one day :)

Ah, yes, it really is a bug(tm), care to post a fix?
