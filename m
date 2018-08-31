Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:40013 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728872AbeHaTpA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 15:45:00 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Peter Oh <peter.oh@bowerswilkins.com>,
        Wen Gong <wgong@qti.qualcomm.com>,
        Wen Gong <wgong@codeaurora.org>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
        "johannes\@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
In-Reply-To: <ae8d9891-b827-7ca5-1375-0280d8f5c194@bowerswilkins.com>
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org> <1533724802-30944-3-git-send-email-wgong@codeaurora.org> <87sh3pdtpg.fsf@toke.dk> <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com> <87mutue4y8.fsf@toke.dk> <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com> <87600eecr7.fsf@toke.dk> <68d91488f58f4a449908fc7eeebb8b34@aptaiexm02f.ap.qualcomm.com> <87tvntb53x.fsf@toke.dk> <ae8d9891-b827-7ca5-1375-0280d8f5c194@bowerswilkins.com>
Date: Fri, 31 Aug 2018 17:36:55 +0200
Message-ID: <87wos61rag.fsf@toke.dk> (sfid-20180831_173701_669059_5CA01C51)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <peter.oh@bowerswilkins.com> writes:

> Hi Toke,
>
>
> On 08/17/2018 04:32 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>
>>>>> Shift 6:
>>>>> wgong@wgong-Latitude-E5440-1:~/flent$ flent -H 192.168.1.7 -t
>>>>> "sk_pacing_shift6" tcp_nup --test-parameter upload_streams=3D1
>>>>
> Does flent have options to set TOS or QoS queue for TCP or UDP test?
> If I add "--test-paramete burst_tos=3D0xe0", will it use corresponding=20
> mac80211 QoS queue?

Yes, for some tests:

- The RRUL test will run four TCP flows in each direction, one marked for
  each 802.11 QoS queue.

- For the rtt_fair* tests you can set them with a test parameter:
--test-parameter markings=3DBE,CS1 to set flows 1 and 2 to BE and CS1
respectively. You can use the rtt_fair_var* tests to get a variable
number of flows (the same host can be specified multiple times by having
different hostnames resolve to the same IP).

-Toke
