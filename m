Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57901 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1FFVf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 17:35:28 -0400
Received: by bwz15 with SMTP id 15so3668880bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 14:35:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110606182147.GE2604@tuxdriver.com>
References: <20110526151422.GA2382@redhat.com> <1306421442.14995.325.camel@wwguy-huron>
 <20110606085851.GA2391@redhat.com> <20110606182147.GE2604@tuxdriver.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Mon, 6 Jun 2011 14:35:06 -0700
Message-ID: <BANLkTimiRaJ7YiB52U_EiW1fn8LcMvTecA@mail.gmail.com> (sfid-20110606_233531_480707_A8CCA130)
Subject: Re: [PATCH v2] iwlagn: use cts-to-self protection on 5000 adapters series
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 6, 2011 at 11:21 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Mon, Jun 06, 2011 at 10:58:52AM +0200, Stanislaw Gruszka wrote:
>> On Thu, May 26, 2011 at 07:50:42AM -0700, Guy, Wey-Yi wrote:
>> > On Thu, 2011-05-26 at 08:14 -0700, Stanislaw Gruszka wrote:
>> > > This patch fixes 802.11n stability and performance regression we have
>> > > since 2.6.35. It boost performance on my 5GHz N-only network from about
>> > > 5MB/s to 8MB/s. Similar percentage boost can be observed on 2.4 GHz.
>> > >
>> > > These are test results of 5x downloading of approximately 700MB iso
>> > > image:
>> > >
>> > > vanilla: 5.27 5.22 4.94 4.47 5.31 ; avr 5.0420 std 0.35110
>> > > patched: 8.07 7.95 8.06 7.99 7.96 ; avr 8.0060 std 0.055946
>> > >
>> > > This was achieved with NetworkManager configured to do not perform
>> > > periodical scans, by configuring constant BSSID. With periodical scans,
>> > > after some time, performance downgrade to unpatched driver level, like
>> > > in example below:
>> > >
>> > > patched: 7.40 7.61 4.28 4.37 4.80 avr 5.6920 std 1.6683
>> > >
>> > > However patch still make better here, since similar test on unpatched
>> > > driver make link disconnects with below messages after some time:
>> > >
>> > > wlan1: authenticate with 00:23:69:35:d1:3f (try 1)
>> > > wlan1: authenticate with 00:23:69:35:d1:3f (try 2)
>> > > wlan1: authenticate with 00:23:69:35:d1:3f (try 3)
>> > > wlan1: authentication with 00:23:69:35:d1:3f timed out
>> > >
>> > > On 2.6.35 kernel patch helps against connection hangs with messages:
>> > >
>> > > iwlagn 0000:20:00.0: queue 10 stuck 3 time. Fw reload.
>> > > iwlagn 0000:20:00.0: On demand firmware reload
>> > > iwlagn 0000:20:00.0: Stopping AGG while state not ON or starting
>> > >
>> > > Cc: stable@kernel.org # 2.6.35+
>> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> > Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>>
>> John, can you apply that patch and push upstream? Or should I
>> repost? I want backport it to Fedora 2.6.35 as it fixes random
>> 11n connection hangs there (common F-14 bug).
>
> Sorry, I was waiting to see if Daniel was going to reply further...
>

Gotcha -- I doubt it harms much, and Stanislaw is right that changing
RTS/CTS to CTS-self is more efficient. This patch is likely a good
thing to have, though I still think there's something else going on ;)

Dan
