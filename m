Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:34691 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727534AbeHJPrf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Aug 2018 11:47:35 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Wen Gong <wgong@qti.qualcomm.com>, Wen Gong <wgong@codeaurora.org>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
        "johannes\@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
In-Reply-To: <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com>
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org> <1533724802-30944-3-git-send-email-wgong@codeaurora.org> <87sh3pdtpg.fsf@toke.dk> <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com>
Date: Fri, 10 Aug 2018 15:17:35 +0200
Message-ID: <87mutue4y8.fsf@toke.dk> (sfid-20180810_151750_374044_F981C74A)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wen Gong <wgong@qti.qualcomm.com> writes:

>> -----Original Message-----
>> From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Toke
>> H=C3=B8iland-J=C3=B8rgensen
>> Sent: Wednesday, August 8, 2018 6:44 PM
>> To: Wen Gong <wgong@codeaurora.org>; ath10k@lists.infradead.org;
>> johannes@sipsolutions.net
>> Cc: linux-wireless@vger.kernel.org
>> Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC Wi=
Fi
>> chips
>>=20
>> Wen Gong <wgong@codeaurora.org> writes:
>>=20
>> > Upstream kernel has an interface to help adjust sk_pacing_shift to
>> > help improve TCP UL throughput.
>> > The sk_pacing_shift is 8 in mac80211, this is based on test with 11N
>> > WiFi chips with ath9k. For QCA6174/QCA9377 PCI 11AC chips, the 11AC
>> > VHT80 TCP UL throughput testing result shows 6 is the optimal.
>> > Overwrite the sk_pacing_shift to 6 in ath10k driver for QCA6174/9377 P=
CI.
>> >
>> > Tested with QCA6174 PCI with firmware
>> > WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377
>> PCI.
>> > It's not a regression with new firmware releases.
>> >
>> > There have 2 test result of different settings:
>> >
>> > ARM CPU based device with QCA6174A PCI with different
>> > sk_pacing_shift:
>> >
>> >  sk_pacing_shift  throughput(Mbps)             CPU utilization
>> >          6            500(-P5)      ~75% idle, Focus on CPU1: ~14%idle
>> >          7            454(-P5)      ~80% idle, Focus on CPU1: ~4%idle
>> >          8               288        ~90% idle, Focus on CPU1: ~35%idle
>> >          9              ~200        ~92% idle, Focus on CPU1: ~50%idle
>> >
>> > 5G TCP UL VTH80 on X86 platform with QCA6174A PCI with
>> > sk_packing_shift set to 6:
>> >
>> >   tcp_limit_output_bytes            throughput(Mbps)
>> >  default(262144)+1 Stream                 336
>> >  default(262144)+2 Streams                558
>> >  default(262144)+3 Streams                584
>> >  default(262144)+4 Streams                602
>> >  default(262144)+5 Streams                598
>> >  changed(2621440)+1 Stream                598
>> >  changed(2621440)+2 Streams               601
>>=20
>> You still haven't provided any latency numbers for these tests, which ma=
kes
>> it impossible to verify that setting sk_pacing_shift to 6 is the right t=
radeoff.
>>=20
>> As I said before, from your numbers I suspect the right setting is actua=
lly 7,
>> which would be 10-20ms less latency under load; way more important than
>> ~50 Mbps...
>>=20
> Hi Toke,
> Could you give the command line for the latency test?
> https://flent.org/intro.html#quick-start
> I used the command but test failed:
> flent tcp_download -p 1 -l 60 -H 192.168.1.5 -t text-to-be-included-in-pl=
ot -o file1.png
> error loading plotter: unable to find plot configuration "1"

Try something like:


flent -H 192.168.1.5 -t "sk_pacing_shift 7" tcp_nup --test-parameter upload=
_streams=3D1


This will note the value of sk_pacing_shift you are testing in the data
file (so change that as appropriate), and you can vary the number of TCP
streams by changing the upload_streams parameter.

Note that in this case I'm assuming you are running Flent on the device
with the kernel you are trying to test, so you want a TCP transfer going
*from* the device. If not, change "tcp_nup" to "tcp_ndown" and
"upload_streams" to "download_streams". Upload is netperf TCP_STREAM
test, and download is TCP_MAERTS.

When running the above command you'll get a summary output on the
terminal that you can paste on the list; and also a data file to plot
things form. For instance, you can do something like 'flent -p ping_cdf
*.flent.gz' to get a CDF plot of all your test results afterwards. You
are also very welcome to send me the .flent.gz data files and I'll take
a look to make sure everything looks reasonable :)

-Toke
