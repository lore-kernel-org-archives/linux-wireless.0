Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:65398 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaJWG5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 02:57:52 -0400
Received: by mail-pd0-f172.google.com with SMTP id ft15so522911pdb.3
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 23:57:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQmHGtO+XCRg1_jJstm+wHRQLU9sEpBRJ7U+_xO3nq7_VA@mail.gmail.com>
References: <CANzpp-=opT==PUf5FhWi_cbB91+RhWk+jB7M4bfUCqh2wzQA2A@mail.gmail.com>
 <CA+BoTQmHGtO+XCRg1_jJstm+wHRQLU9sEpBRJ7U+_xO3nq7_VA@mail.gmail.com>
From: Okhwan Lee <ohlee@mwnl.snu.ac.kr>
Date: Thu, 23 Oct 2014 15:57:20 +0900
Message-ID: <CANzpp-kV8LzPgeXHq=DHKsLSdTT+-9gjj08RXST4r3-QOtkanw@mail.gmail.com> (sfid-20141023_085755_293944_0B299B99)
Subject: Re: Change channel bandwidth without iw command
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thank you for your answer.

> The panic printout would be most helpful. My best guess is this
> crashes in ath10k_dbg() at the very beginning of ath10k_config_chan
> because ar->chandef.chan is NULL. This is probably the case since you
> use monitor_chandef which is probably "empty" at the point you invoke
> your code.

First, we confirm that ar->chandef.chan is not NULL.
We find out the the error occurs when "wait_for_completion_timeout" is called.
Ath10k is trying to stop vdev (monitor_dev) when change the channel setting.
We have no idea about the details of function, but it make waiting
time duration for previous event.
We also test by replacing wait_for_completion_timeout to
wait_for_completion (i.e., it use maximum timeout value)
But the kernel panic is still there.

However, it is not easy to printout the messages when the panic is occurred,
because the system stop (similar to bluescreen in widnows?).
After reboot the system, the log messagess from panic is not recored
in kernel log messages (/var/log/syslog, dmesg, kernel_llog) .

> The iw set channel is for monitor interfaces only so trying to make it
> work with, e.g. a station interface will bring you pain.

We already know about this. So, we test this in monitor mode.

Thank you for your answer.

Sincerely yours,

Okhwan

2014-10-22 19:40 GMT+09:00 Michal Kazior <michal.kazior@tieto.com>:
> On 22 October 2014 12:14, Okhwan Lee <ohlee@mwnl.snu.ac.kr> wrote:
>> Hi,
>>
>> We are trying to implement a protocol to evaluate the performance our
>> algorithm using QCA9880.
>>
>> To implement our protocol, a receiver have to change the bandwidth
>> when a Action frame (what we define) is successfully received.
>> We know that the QCA9880 can change bandwidth by using iw command in
>> monitor mode.
>> So, we use similar function path used by "iw dev set freq ..."
>> When the receiver detects the reception of the Action frame we call
>> "ieee80211_set_monitor_channel" at the end of ieee80211_rx as follows:
>>
>> /*************** net/mac80211/rx.c ******************/
>>
>> // receive action frame, change bandwidth 80 -> 20
>>
>>                 rtnl_lock(); //lock rtnetlink used in pre_doit of nl80211
>>                 chandef = local->monitor_chandef; // copy current chandef
>>                 chandef.width = NL80211_CHAN_WIDTH_20; // set bandwidth
>>                 chandef.center_freq1 = 5180; // set center freq...
>>                 ieee80211_set_monitor_channel(wiphy, &chandef);
>>                 rtnl_unlock();
>>
>> /********************************************************/
>
> If my understanding is correct you're doing it wrong.
>
> You probably want to modify chanctx of a vif the frame is associated
> with and notify the driver via appropriate mac80211 helpers instead of
> the hack above. Remember to get your locking right.
>
>
>> However, the receiver invokes kernel panic when receives the Action frame.
>> As fas as we know, the panic is occurred in ath10k_config_chan of
>> ath10k device driver.
>
> The panic printout would be most helpful. My best guess is this
> crashes in ath10k_dbg() at the very beginning of ath10k_config_chan
> because ar->chandef.chan is NULL. This is probably the case since you
> use monitor_chandef which is probably "empty" at the point you invoke
> your code.
>
>
>> To the best our knowledge, our implementation exploits same function
>> path of iw command in nl80211, cfg80211, mac80211 and ath10k.
>> Moreover, we confirm that the input parameters (wiphy, chandef) in our
>> implementation are identical to the parameters used by iw command.
>>
>> Is there any reason why we cannot change bandwidth?
>> Of course, iw command work correctly.
>
> The iw set channel is for monitor interfaces only so trying to make it
> work with, e.g. a station interface will bring you pain.
>
>
> Michał
