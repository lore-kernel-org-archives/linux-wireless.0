Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f203.google.com ([209.85.212.203]:36735 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbZIYOjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 10:39:05 -0400
Received: by vws41 with SMTP id 41so1696340vws.4
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 07:39:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909241015.06706.hs4233@mail.mn-solutions.de>
References: <200909210902.23723.hs4233@mail.mn-solutions.de>
	 <1253662161.2510.59.camel@localhost.localdomain>
	 <200909241015.06706.hs4233@mail.mn-solutions.de>
Date: Fri, 25 Sep 2009 10:39:08 -0400
Message-ID: <b6c5339f0909250739r2bcb8528tbc4d98b574e0e198@mail.gmail.com>
Subject: Re: getting "ath5k phy0: noise floor calibration timeout"
From: Bob Copeland <me@bobcopeland.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 4:15 AM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
> On ath5k-devel, there was a mail "[ath5k-devel] [RFC/RFT] ath5k:
> use noise calibration from madwifi hal" from Bob Copeland.
>
> Part of the patch is "- we do not complain if NF calibration
> isn't complete, instead we keep the last read value.".

Yeah, NF calibration timeout happens all the time (also in
madwifi/ath9k) so we should just silence it.  At best, it indicates
a problem that the user can't do anything about; at worst, it
leads to bug reports accusing the NF calibration of wholly unrelated
things.

I really should finish testing and push that patch, real life has
just been in the way lately.

-- 
Bob Copeland %% www.bobcopeland.com
