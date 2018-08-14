Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-tai-02.qualcomm.com ([103.229.16.227]:38763 "EHLO
        alexa-out-tai-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728483AbeHNIlP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 04:41:15 -0400
From: Wen Gong <wgong@qti.qualcomm.com>
To: =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Wen Gong <wgong@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi
 chips
Date: Tue, 14 Aug 2018 05:55:31 +0000
Message-ID: <68d91488f58f4a449908fc7eeebb8b34@aptaiexm02f.ap.qualcomm.com> (sfid-20180814_075540_903011_1BC8BAB1)
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
 <1533724802-30944-3-git-send-email-wgong@codeaurora.org>
 <87sh3pdtpg.fsf@toke.dk>
 <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com>
 <87mutue4y8.fsf@toke.dk>
 <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com>
 <87600eecr7.fsf@toke.dk>
In-Reply-To: <87600eecr7.fsf@toke.dk>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Toke H=F8iland-J=F8rgensen <toke@toke.dk>
> Sent: Monday, August 13, 2018 7:18 PM
> To: Wen Gong <wgong@qti.qualcomm.com>; Wen Gong
> <wgong@codeaurora.org>; ath10k@lists.infradead.org;
> johannes@sipsolutions.net
> Cc: linux-wireless@vger.kernel.org
> Subject: RE: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiF=
i
> chips
>=20
> Wen Gong <wgong@qti.qualcomm.com> writes:
>=20
> > Hi Toke,
> >
> > I have tested with your method for shift 6/8/10/7 all twice time in
> > open air environment.
>=20
> Great, thanks!
>=20
> > Shift 6:
> > wgong@wgong-Latitude-E5440-1:~/flent$ flent -H 192.168.1.7 -t
> > "sk_pacing_shift6" tcp_nup --test-parameter upload_streams=3D1
>=20
> Just to be sure: You are running this on your laptop? And that laptop has=
 the
> ath10k and the modified kernel you are testing? Is 192.168.1.7 the AP or
> another device?
Hi Toke,
Yes, I run on my laptop(Dell LATITUDE E5440 + QCA6174 PCI wireless card) in=
 open air environment,
Kernel is 4.18.0-rc2-wt-ath+ #2 SMP which is built myself.
The mac80211.ko/ath10k is built with the 2 patches.
192.168.1.7 is another device(PC installed with 4.4.0-116-generic #140~14.0=
4.1-Ubuntu)
>=20
> I'd like to see what happens when the link is fully saturated my multiple
> streams as well. Could you repeat the tests with upload_streams=3D5, plea=
se?
> And if you could share the .flent.gz files (upload them somewhere, or ema=
il
> me off-list), that would be useful as well :)

Test result with upload_streams=3D5:

sk_pacing_shift6:
wgong@wgong-Latitude-E5440-1:~/flent/5stream$ flent -H 192.168.1.7 -t "sk_p=
acing_shift6" tcp_nup --test-parameter upload_streams=3D5
Started Flent 1.2.2 using Python 2.7.12.
Starting tcp_nup test. Expected run time: 70 seconds.
Data file written to ./tcp_nup-2018-08-14T105332.356811.sk_pacing_shift6.fl=
ent.gz.
Summary of tcp_nup test run 'sk_pacing_shift6' (at 2018-08-14 02:53:32.3568=
11):

                           avg       median          # data pts
 Ping (ms) ICMP :        20.46        13.85 ms              350
 TCP upload avg :        66.30        68.71 Mbits/s         301
 TCP upload sum :       331.49       343.55 Mbits/s         301
 TCP upload::1  :        60.80        64.65 Mbits/s         202
 TCP upload::2  :        77.72        82.89 Mbits/s         211
 TCP upload::3  :        60.52        56.09 Mbits/s         202
 TCP upload::4  :        67.39        73.56 Mbits/s         204
 TCP upload::5  :        65.06        71.97 Mbits/s         201
wgong@wgong-Latitude-E5440-1:~/flent/5stream$ flent -H 192.168.1.7 -t "sk_p=
acing_shift6" tcp_nup --test-parameter upload_streams=3D5
Started Flent 1.2.2 using Python 2.7.12.
Starting tcp_nup test. Expected run time: 70 seconds.
Data file written to ./tcp_nup-2018-08-14T105554.583603.sk_pacing_shift6.fl=
ent.gz.
Summary of tcp_nup test run 'sk_pacing_shift6' (at 2018-08-14 02:55:54.5836=
03):

                           avg       median          # data pts
 Ping (ms) ICMP :        20.86        13.80 ms              350
 TCP upload avg :        75.88        83.17 Mbits/s         301
 TCP upload sum :       379.42       415.84 Mbits/s         301
 TCP upload::1  :        82.07        90.73 Mbits/s         225
 TCP upload::2  :        74.08        78.29 Mbits/s         204
 TCP upload::3  :        70.44        75.65 Mbits/s         217
 TCP upload::4  :        82.70        92.86 Mbits/s         223
 TCP upload::5  :        70.13        76.87 Mbits/s         210

sk_pacing_shift7:
wgong@wgong-Latitude-E5440-1:~/flent/5stream$ flent -H 192.168.1.7 -t "sk_p=
acing_shift7" tcp_nup --test-parameter upload_streams=3D5
Started Flent 1.2.2 using Python 2.7.12.
Starting tcp_nup test. Expected run time: 70 seconds.
Data file written to ./tcp_nup-2018-08-14T105759.169367.sk_pacing_shift7.fl=
ent.gz.
Summary of tcp_nup test run 'sk_pacing_shift7' (at 2018-08-14 02:57:59.1693=
67):

                           avg       median          # data pts
 Ping (ms) ICMP :        24.66        15.55 ms              350
 TCP upload avg :        65.33        72.83 Mbits/s         301
 TCP upload sum :       326.67       363.10 Mbits/s         301
 TCP upload::1  :        77.60        92.93 Mbits/s         214
 TCP upload::2  :        67.22        75.95 Mbits/s         213
 TCP upload::3  :        65.81        74.54 Mbits/s         205
 TCP upload::4  :        63.06        70.37 Mbits/s         207
 TCP upload::5  :        52.98        55.78 Mbits/s         198
wgong@wgong-Latitude-E5440-1:~/flent/5stream$ flent -H 192.168.1.7 -t "sk_p=
acing_shift7" tcp_nup --test-parameter upload_streams=3D5
Started Flent 1.2.2 using Python 2.7.12.
Starting tcp_nup test. Expected run time: 70 seconds.
Data file written to ./tcp_nup-2018-08-14T105923.620572.sk_pacing_shift7.fl=
ent.gz.
Summary of tcp_nup test run 'sk_pacing_shift7' (at 2018-08-14 02:59:23.6205=
72):

                           avg       median          # data pts
 Ping (ms) ICMP :        25.03        14.25 ms              350
 TCP upload avg :        74.35        85.64 Mbits/s         297
 TCP upload sum :       371.77       428.19 Mbits/s         297
 TCP upload::1  :        74.12        82.55 Mbits/s         216
 TCP upload::2  :        67.78        71.87 Mbits/s         208
 TCP upload::3  :        82.40        94.72 Mbits/s         210
 TCP upload::4  :        70.77        82.43 Mbits/s         206
 TCP upload::5  :        76.70        88.62 Mbits/s         210

sk_pacing_shift8:
wgong@wgong-Latitude-E5440-1:~/flent/5stream$ flent -H 192.168.1.7 -t "sk_p=
acing_shift8" tcp_nup --test-parameter upload_streams=3D5
Started Flent 1.2.2 using Python 2.7.12.
Starting tcp_nup test. Expected run time: 70 seconds.
Data file written to ./tcp_nup-2018-08-14T110334.670845.sk_pacing_shift8.fl=
ent.gz.
Summary of tcp_nup test run 'sk_pacing_shift8' (at 2018-08-14 03:03:34.6708=
45):

                           avg       median          # data pts
 Ping (ms) ICMP :        25.03        19.50 ms              350
 TCP upload avg :        58.11        59.70 Mbits/s         301
 TCP upload sum :       290.53       298.51 Mbits/s         301
 TCP upload::1  :        51.37        51.74 Mbits/s         197
 TCP upload::2  :        42.02        43.66 Mbits/s         192
 TCP upload::3  :        61.17        62.33 Mbits/s         200
 TCP upload::4  :        66.11        70.31 Mbits/s         198
 TCP upload::5  :        69.86        76.31 Mbits/s         202
wgong@wgong-Latitude-E5440-1:~/flent/5stream$ flent -H 192.168.1.7 -t "sk_p=
acing_shift8" tcp_nup --test-parameter upload_streams=3D5
Started Flent 1.2.2 using Python 2.7.12.
Starting tcp_nup test. Expected run time: 70 seconds.
Data file written to ./tcp_nup-2018-08-14T110557.587769.sk_pacing_shift8.fl=
ent.gz.
Summary of tcp_nup test run 'sk_pacing_shift8' (at 2018-08-14 03:05:57.5877=
69):

                           avg       median          # data pts
 Ping (ms) ICMP :        21.50        13.05 ms              350
 TCP upload avg :        61.59        62.00 Mbits/s         301
 TCP upload sum :       307.93       310.01 Mbits/s         301
 TCP upload::1  :        69.70        76.22 Mbits/s         210
 TCP upload::2  :        68.51        74.88 Mbits/s         207
 TCP upload::3  :        71.06        77.57 Mbits/s         200
 TCP upload::4  :        47.08        51.42 Mbits/s         196
 TCP upload::5  :        51.58        51.98 Mbits/s         203

sk_pacing_shift10:
wgong@wgong-Latitude-E5440-1:~/flent/5stream$ flent -H 192.168.1.7 -t "sk_p=
acing_shift10" tcp_nup --test-parameter upload_streams=3D5
Started Flent 1.2.2 using Python 2.7.12.
Starting tcp_nup test. Expected run time: 70 seconds.
Data file written to ./tcp_nup-2018-08-14T110814.434543.sk_pacing_shift10.f=
lent.gz.
Summary of tcp_nup test run 'sk_pacing_shift10' (at 2018-08-14 03:08:14.434=
543):

                           avg       median          # data pts
 Ping (ms) ICMP :        31.57        19.35 ms              350
 TCP upload avg :        56.61        62.61 Mbits/s         301
 TCP upload sum :       283.07       313.07 Mbits/s         301
 TCP upload::1  :        39.39        42.96 Mbits/s         187
 TCP upload::2  :        62.20        72.39 Mbits/s         193
 TCP upload::3  :        61.72        74.31 Mbits/s         191
 TCP upload::4  :        61.86        73.74 Mbits/s         190
 TCP upload::5  :        57.90        65.11 Mbits/s         193
wgong@wgong-Latitude-E5440-1:~/flent/5stream$ flent -H 192.168.1.7 -t "sk_p=
acing_shift10" tcp_nup --test-parameter upload_streams=3D5
Started Flent 1.2.2 using Python 2.7.12.
Starting tcp_nup test. Expected run time: 70 seconds.
Data file written to ./tcp_nup-2018-08-14T110931.986159.sk_pacing_shift10.f=
lent.gz.
Summary of tcp_nup test run 'sk_pacing_shift10' (at 2018-08-14 03:09:31.986=
159):

                           avg       median          # data pts
 Ping (ms) ICMP :        19.23        13.20 ms              350
 TCP upload avg :        76.36        81.37 Mbits/s         301
 TCP upload sum :       381.80       406.85 Mbits/s         301
 TCP upload::1  :        64.95        67.91 Mbits/s         212
 TCP upload::2  :        82.16        92.35 Mbits/s         215
 TCP upload::3  :        67.51        70.18 Mbits/s         213
 TCP upload::4  :        77.42        82.11 Mbits/s         232
 TCP upload::5  :        89.76        99.96 Mbits/s         226

>=20
> Thanks,
>=20
> -Toke
