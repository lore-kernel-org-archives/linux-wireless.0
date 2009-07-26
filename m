Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:53709 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbZGZGeo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2009 02:34:44 -0400
Received: by bwz28 with SMTP id 28so2063787bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 23:34:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248585928.28545.166.camel@violet>
References: <1248531054.15242.16.camel@maxim-laptop>
	 <1248558755.11389.21.camel@mj> <1248561109.4753.9.camel@maxim-laptop>
	 <1248562407.7314.1.camel@maxim-laptop>
	 <1248585928.28545.166.camel@violet>
Date: Sat, 25 Jul 2009 23:34:43 -0700
Message-ID: <bcd1ba70907252334y2fd88cf0i4fe812f4fd686c8e@mail.gmail.com>
Subject: Re: [ipw3945-devel] [BUG] Current head of wireless testing unusable
From: John Ranson <ranson@analager.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Maxim and Marcel,

On Sat, Jul 25, 2009 at 10:25 PM, Marcel Holtmann<marcel@holtmann.org> wrote:
> Hi Maxim,
>
>> > > > I probably should work more to did these bugs out myself, but anyway I
>> > > > want to let you know what I currently see.
>> > > >
>> > > > First system oopses just after NM starts up, happens always, and after
>> > > > planting few test points bug happens somewhere in following lines.
>> > >
>> > > We are discussing a bug in the scan state machine in another thread,
>> > > which could have nasty consequences in not caught.  And I don't quite
>> > > understand why my system was catching it immediately, maybe because I'm
>> > > using gcc 4.4, which has array bounds checking.
>> > Yea, there are two patches with same title for this, I applied the
>> > newer.
>> >
>> > Currently thanks to Johannes Berg, the patch
>> > [PATCH] nl80211: add missing parameter clearing
>> > Fixes this nasty oops, now wireless more or less works, but plenty of
>> > problems still, first it oopses on reconnect as inilialized from
>> > wpa_supplicant, second iwconfig misses most of its settings, and
>> > probably thus NM think signal level is zero. If I switch to good old
>> > wext in wpa_supplicant, it works just fine and none of above problems
>> > present (I recheck this again to be sure)
>> Except very frequent reconnects,
>> "[  919.250097] No probe response from AP 00:1b:9e:d8:77:02 after 200ms, disconnecting."
>
> I have the same issue with my Intel 5350 card and if the signal strength
> of the AP gets a little bit weaker.
>

I also am seeing this frequently, and I'm sitting about six feet from
my access point. I don't think that it's necessarily related to signal
strength.

John
