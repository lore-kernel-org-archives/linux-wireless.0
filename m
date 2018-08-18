Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:55975 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbeHRFeY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 01:34:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAKfDRXia3zwW9Q=7RZGqK_DWCsyQzG4KEZHsyHzGcNb70Ge1kA@mail.gmail.com>
References: <20180812145207.11395-1-kristian.evensen@gmail.com>
 <871sb3zc3v.fsf@kamboji.qca.qualcomm.com> <5B708025.4090906@broadcom.com>
 <CAJ0CqmVZNAnHwnU4YqRRv7R8DyHi2MiFJr1bvQDPVszUU5Ez3g@mail.gmail.com> <CAKfDRXia3zwW9Q=7RZGqK_DWCsyQzG4KEZHsyHzGcNb70Ge1kA@mail.gmail.com>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Sat, 18 Aug 2018 04:28:27 +0200
Message-ID: <CAOq732JS81W+UGfpQ4KnswoV0tTgvCA-c5ZFoSmmVfatJfHRGQ@mail.gmail.com> (sfid-20180818_043033_721831_1AA3E8E2)
Subject: Re: [PATCH] mt76: Enable NL80211_EXT_FEATURE_CQM_RSSI_LIST
To: Kristian Evensen <kristian.evensen@gmail.com>
Cc: lorenzo.bianconi@redhat.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 13 August 2018 at 16:25, Kristian Evensen <kristian.evensen@gmail.com> wrote:
> On Mon, Aug 13, 2018 at 12:55 PM Lorenzo Bianconi
> <lorenzo.bianconi@redhat.com> wrote:
>> According to my understanding (please correct me if I am wrong)
>> BSS_CHANGED_CQM is only needed if CQM_RSSI is handled
>> by the driver/fw, while if it is not set mac80211 will take care of that
>> in ieee80211_handle_beacon_sig routine.
>> I am AFK at the moment, I will test that patch when I am back from vacations.
>
> That matches my understanding as well (base on for example the message
> for commit ae44b502669d0cd1f167cdb48994292aa20fd3dd).

This is right, mt7601u had this flag added in that commit but the mt76
drivers were added later.  It seems mt76_rx_convert always sets the
ieee80211_rx_status.signal field so mac80211 can check the rssi values
and call any CQM callbacks if needed.

Best regards
