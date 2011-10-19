Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:61729 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1JSS1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 14:27:51 -0400
Received: from hpaq6.eem.corp.google.com (hpaq6.eem.corp.google.com [172.25.149.6])
	by smtp-out.google.com with ESMTP id p9JIRjjv020851
	for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2011 11:27:45 -0700
Received: from iaeo4 (iaeo4.prod.google.com [10.12.166.4])
	by hpaq6.eem.corp.google.com with ESMTP id p9JIQPo4023076
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2011 11:27:44 -0700
Received: by iaeo4 with SMTP id o4so4092144iae.9
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2011 11:27:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111019115520.79cfaef8@mj>
References: <loom.20110621T215346-191@post.gmane.org>
	<BANLkTik0umam7S+E1oog0LTEErMz-dZamg@mail.gmail.com>
	<1308750102.64154.YahooMailRC@web161214.mail.bf1.yahoo.com>
	<1308750416.29571.10.camel@jlt3.sipsolutions.net>
	<1308753669.17439.YahooMailRC@web161208.mail.bf1.yahoo.com>
	<1308754204.29571.15.camel@jlt3.sipsolutions.net>
	<1308755270.21489.YahooMailRC@web161204.mail.bf1.yahoo.com>
	<BANLkTi=Ob1H7XdG5-21SnjkuyVF9xw+xBA@mail.gmail.com>
	<1319018802.31281.YahooMailNeo@web161205.mail.bf1.yahoo.com>
	<CAJ-VmokZibCys+9ZLg6yEbauJfbgErbezMcTZ2SjPmR9SMgQ7w@mail.gmail.com>
	<20111019115520.79cfaef8@mj>
Date: Wed, 19 Oct 2011 11:27:43 -0700
Message-ID: <CA+yqC4be-6h-AY9G6YJCtNBRFQ51UyQNxFtJfG85gqZufiDF1g@mail.gmail.com> (sfid-20111019_202755_251206_94B2901E)
Subject: Re: [ath5k-devel] Performance regression between Madwifi/net80211 and ath5k/mac80211
From: Sam Leffler <sleffler@google.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Joerg Pommnitz <pommnitz@yahoo.com>,
	Bob Copeland <me@bobcopeland.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 19, 2011 at 8:55 AM, Pavel Roskin <proski@gnu.org> wrote:
> On Wed, 19 Oct 2011 19:33:53 +0800
> Adrian Chadd <adrian@freebsd.org> wrote:
>
>> .. does madwifi have that net80211 "aggressive mode" by default, where
>> it overrides the best-effort WME queue parameters to allow for
>> bursting?
>
> I tried madwifi-0.9.4 snapshot on a CM9 card, and I got:
>
> # iwpriv ath0 get_abolt
> ath0      get_abolt:218
>
> 218 is 0xda, which means that the following capabilities are enabled:
>
> IEEE80211_ABOLT_TURBO_PRIME
> IEEE80211_ABOLT_FAST_FRAME
> IEEE80211_ABOLT_BURST
> IEEE80211_ABOLT_XR
> IEEE80211_ABOLT_AR
>
> And those are not enabled:
>
> IEEE80211_ABOLT_TURBO_G
> IEEE80211_ABOLT_COMPRESSION
> IEEE80211_ABOLT_WME_ELE
>
> I would just unset all capabilities and retry.
>
>> I see exactly that difference in FreeBSD (33mbit vs 22mbit) when I
>> disable that aggressive mode code.

Bursting will get you to ~28 and FF's are likely the reset (no dynamic
turbo on freebsd).  It would be nice to have control in linux to
explicitly turn on/off bursting but the usual way people do it is to
negotiate wmm and force the txop limit.

BTW whenever you see a performance difference the first thing to look
at is packets/sec.  I've not found any linux tools that give me this a
la athstats/wlanstats on freebsd.

-Sam
