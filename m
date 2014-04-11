Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53062 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaDKUOC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 16:14:02 -0400
Message-ID: <1397247226.4643.8.camel@jlt4.sipsolutions.net> (sfid-20140411_221408_485850_22F860D4)
Subject: Re: [RFC/RFT] cfg80211: reg: track crda request
From: Johannes Berg <johannes@sipsolutions.net>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>, collen@cozybit.com
Date: Fri, 11 Apr 2014 22:13:46 +0200
In-Reply-To: <294574679.20140411220931@eikelenboom.it>
References: <1397219374-3280-1-git-send-email-janusz.dziedzic@tieto.com>
	 <2710039777.20140411192110@eikelenboom.it>
	 <CAFED-jkPtXU8moGrb4XiriU-c7WokgSiXq6g0jCLOhk3dJnoLg@mail.gmail.com>
	 <294574679.20140411220931@eikelenboom.it>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-04-11 at 22:09 +0200, Sander Eikelenboom wrote:

> I would first like to know if Johannes likes this solution or not.

Heh, I guess that's only fair.

> With previous patches from Luis they were blocked after testing and debugging, so let him 
> first speak out if he likes the approach or not.

I think this looks fine. My main complaint with Luis's patches (besides
reportedly breaking some other use cases) was that he was piggy-backing
on some completely unrelated thing to try to recover something. Here we
have an explicit delayed work struct so that seems fine.

And I really like the part where Janusz moves the delayed_work setting
where it belongs - the CRDA call function :)

johannes

