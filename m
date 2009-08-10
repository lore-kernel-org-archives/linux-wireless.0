Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f172.google.com ([209.85.212.172]:53929 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbZHJQE7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 12:04:59 -0400
Received: by vws2 with SMTP id 2so2765863vws.4
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 09:04:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890908100850v1cbb4252j3136245ba4d316b6@mail.gmail.com>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
	 <20090810150455.GB2733@tuxdriver.com>
	 <43e72e890908100850v1cbb4252j3136245ba4d316b6@mail.gmail.com>
Date: Mon, 10 Aug 2009 12:04:59 -0400
Message-ID: <b6c5339f0908100904t46957338u1391e1083c042018@mail.gmail.com>
Subject: Re: wireless regressions -- Re: 2.6.31-rc5-git5: Reported regressions
	from 2.6.30
From: Bob Copeland <bcopeland@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Fabio Comolli <fabio.comolli@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 10, 2009 at 11:50 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Mon, Aug 10, 2009 at 8:04 AM, John W. Linville<linville@tuxdriver.com> wrote:
>> On Sun, Aug 09, 2009 at 10:36:49PM +0200, Rafael J. Wysocki wrote:
>>> This message contains a list of some regressions from 2.6.30, for which there
>>> are no fixes in the mainline I know of.  If any of them have been fixed already,
>>> please let me know.
>>
>> Wireless-related ones...
>
> Some notes on some of these.
>
>>> Unresolved regressions
>>> ----------------------
>>
>>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13947
>>> Subject               : Libertas: Association request to the driver failed
>>> Submitter     : Daniel Mack <daniel@caiaq.de>
>>> Date          : 2009-08-07 19:11 (3 days old)
>>> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=57921c312e8cef72ba35a4cfe870b376da0b1b87
>>> References    : http://marc.info/?l=linux-kernel&m=124967234311481&w=4
>>> Handled-By    : Roel Kluin <roel.kluin@gmail.com>
>>>
>>>
>>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13943
>>> Subject               : WARNING: at net/mac80211/mlme.c:2292 with ath5k
>>> Submitter     : Fabio Comolli <fabio.comolli@gmail.com>
>>> Date          : 2009-08-06 20:15 (4 days old)
>>> References    : http://marc.info/?l=linux-kernel&m=124958978600600&w=4
>
> As I noted earlier this comes from the fact that a driver or mac80211
> is queuing work onto the mac80211 workqueue when we already ran the
> mac80211 suspend callbacks and we haven't yet resumed. There have been
> several fixes for these, for both drivers and mac80211. We've already
> pushed them to wireless-testing but I do not recall which ones have
> been propagated to 2.6.31 as fixes.

This is on my todo and I haven't looked into this very hard yet,
but afaik ath5k doesn't (directly) use the mac80211 workqueue, so
my guess in Fabio's case would be further up the stack.

-- 
Bob Copeland %% www.bobcopeland.com
