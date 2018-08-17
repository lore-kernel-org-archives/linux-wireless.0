Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:45895 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbeHQOfw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Aug 2018 10:35:52 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Wen Gong <wgong@qti.qualcomm.com>, Wen Gong <wgong@codeaurora.org>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
        "johannes\@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
In-Reply-To: <68d91488f58f4a449908fc7eeebb8b34@aptaiexm02f.ap.qualcomm.com>
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org> <1533724802-30944-3-git-send-email-wgong@codeaurora.org> <87sh3pdtpg.fsf@toke.dk> <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com> <87mutue4y8.fsf@toke.dk> <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com> <87600eecr7.fsf@toke.dk> <68d91488f58f4a449908fc7eeebb8b34@aptaiexm02f.ap.qualcomm.com>
Date: Fri, 17 Aug 2018 13:32:50 +0200
Message-ID: <87tvntb53x.fsf@toke.dk> (sfid-20180817_133248_263379_1C92EBBD)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wen Gong <wgong@qti.qualcomm.com> writes:

>> -----Original Message-----
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>> Sent: Monday, August 13, 2018 7:18 PM
>> To: Wen Gong <wgong@qti.qualcomm.com>; Wen Gong
>> <wgong@codeaurora.org>; ath10k@lists.infradead.org;
>> johannes@sipsolutions.net
>> Cc: linux-wireless@vger.kernel.org
>> Subject: RE: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC Wi=
Fi
>> chips
>>=20
>> Wen Gong <wgong@qti.qualcomm.com> writes:
>>=20
>> > Hi Toke,
>> >
>> > I have tested with your method for shift 6/8/10/7 all twice time in
>> > open air environment.
>>=20
>> Great, thanks!
>>=20
>> > Shift 6:
>> > wgong@wgong-Latitude-E5440-1:~/flent$ flent -H 192.168.1.7 -t
>> > "sk_pacing_shift6" tcp_nup --test-parameter upload_streams=3D1
>>=20
>> Just to be sure: You are running this on your laptop? And that laptop ha=
s the
>> ath10k and the modified kernel you are testing? Is 192.168.1.7 the AP or
>> another device?
> Hi Toke,
> Yes, I run on my laptop(Dell LATITUDE E5440 + QCA6174 PCI wireless card) =
in open air environment,
> Kernel is 4.18.0-rc2-wt-ath+ #2 SMP which is built myself.
> The mac80211.ko/ath10k is built with the 2 patches.
> 192.168.1.7 is another device(PC installed with 4.4.0-116-generic #140~14=
.04.1-Ubuntu)
>>=20
>> I'd like to see what happens when the link is fully saturated my multiple
>> streams as well. Could you repeat the tests with upload_streams=3D5, ple=
ase?
>> And if you could share the .flent.gz files (upload them somewhere, or em=
ail
>> me off-list), that would be useful as well :)
>
> Test result with upload_streams=3D5:

Sorry for the delay in looking at this, I've been terribly busy this
week; will get back to it in more detail next week.

One question for now: In the results you quote below the total
throughput is way lower than the up to 600 mbps you quoted in the patch
description. How did you run your original tests to achieve that high a
throughput?

-Toke
