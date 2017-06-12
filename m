Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:36716 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752065AbdFLVR1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 17:17:27 -0400
Received: by mail-wr0-f179.google.com with SMTP id v111so114084592wrc.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jun 2017 14:17:26 -0700 (PDT)
Subject: Re: brcmfmac: brcm43430 Invalid mailbox value issue
To: James Hughes <james.hughes@raspberrypi.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Chi-Hsien Lin <chln@cypress.com>
References: <CAE_XsMKBQJDVbiH1RN_9zvOtToQgA74wbZWmnfXLbDAATua_kA@mail.gmail.com>
 <8ec01afb-7c9d-2cde-0007-b4d9fd2dbdbd@broadcom.com>
 <CAE_XsMJ8DxHUEpegYzc-9KOAsQveYxKzRea+KJ2Jfk3VQTzT7w@mail.gmail.com>
 <CAE_XsMJoCQdBOU9Ky233sqfrgv5xqBg_o1Hy5Q3MHCSsDheTYg@mail.gmail.com>
 <CAE_XsMKLp16LE-GOApSkfaTDbBFnf3YFeHGs-CmLaxs6MFDsiA@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5f90b587-b77b-8d27-7e11-f1127d9a701c@broadcom.com> (sfid-20170612_231731_684207_4464CD57)
Date: Mon, 12 Jun 2017 23:17:23 +0200
MIME-Version: 1.0
In-Reply-To: <CAE_XsMKLp16LE-GOApSkfaTDbBFnf3YFeHGs-CmLaxs6MFDsiA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Chi-Hsien Lin

On 12-06-17 11:54, James Hughes wrote:
> On 24 May 2017 at 16:14, James Hughes <james.hughes@raspberrypi.org> wrote:
>> On 24 May 2017 at 14:16, James Hughes <james.hughes@raspberrypi.org> wrote:
>>> On 24 May 2017 at 14:13, Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
>>>> On 24-05-17 14:50, James Hughes wrote:
>>>>> We are seeing an issue on Raspberry Pi which uses the bcm43430 chip. It's
>>>>> been tested up to 4.9 which still shows the issue (it's been there for some
>>>>> time, > 1yr). I'm trying to find someone who can test on 4.11 as I cannot
>>>>> replicate  (The latest kernel we have that works on a Pi)
>>>>>
>>>>> It exhibits as a log entry, and subsequent death of wireless connectivity.
>>>>>
>>>>> "Unknown mailbox data content: 0x40012"
>>>>>
>>>>> Look at the driver code, it appears to be checking the return
>>>>> value from a mailbox (presumably the one to the chip firmware), which
>>>>> has the 0x4 in the top word which shouldn't be there.
>>>>>
>>>>> The driver simply adds a log entry, but otherwise ignores the situation.
>>>>> However, we see wireless failure from this point.
>>>>>
>>>>> Since I believe this value is being returned from the chip, I cannot
>>>>> investigate much further. The public datasheet is of no help. We do appear
>>>>> to be using the latest firmware file.
>>>>>
>>>>> I'm not sure how to proceed on this one. It would be interesting to know
>>>>> under what circumstances that value can be returned from the mailbox.
>>>>>
>>>>> More details can be found at the end of this github issue.
>>>>>
>>>>> https://github.com/raspberrypi/linux/issues/1342
>>>>
>>>> Hi James,
>>>>
>>>> I looked through the issue on github and it seems you are getting -110
>>>> (-ETIMEDOUT) on SDIO transfers. This could be a signal integrity issue
>>>> of the SDIO bus signals, which may happen if the RPi3 power supply can
>>>> not provide enough amps. So you could try to replicate it by
>>>> deliberately use a power supply below specs.
>>>>
>>>> I did not get my RPi3 going yet, but I can try next monday or so. Office
>>>> closed due to Ascension day. Do you know what SDIO host controller is
>>>> used on RPi3? I can check myself, but if you know the answer up front
>>>> let me know.
>>>>
>>>> Regards,
>>>> Arend
>>>
>>> Hi Arend,
>>>
>>> It's the one built in to the SoC (the bcm2835) and I believe is an
>>> Arasan device. If you need anything else (HW etc) please let me know.
>>>
>>> I'll try the low power setup you suggest. Might be the reason why I
>>> cannot replicate, I always use decent power supplies.
>>>
>>> James
>>
>> Spent an hour or so trying the low power situation. Got to the point
>> where USB devices were dropping out, but didn't see any SDIO timeouts
>> or mailbox errors in dmesg. Will keep looking though - absence of
>> evidence is not evidence of absence etc etc.
>>
>> James
> 
> Hi Arend, all,
> 
> Is there anything I can do to help track this down? Further low power
> testing didn't provoke the issue. We are continually getting reports
> on this issue, the github issue has some more, perhaps relevant, data
> now. There is a possibility it may be channel related.
> 
> https://github.com/raspberrypi/linux/issues/1342

I have been thinking about this and I recall three scenarios resulting
in -110 (-ETIMEDOUT) error on sdio transfers: 1) bad sdio signals, 2)
bus sleep state transitions, and 3) device signals CARD_BUSY.

So you checked the first scenario. To investigate 2) you could set
define BRCMF_IDLE_INTERVAL to zero, which will basically leave sdio on
the device in normal state (less power-savings) when the device is idle.

For 3) the mmc_host_ops define following callback:

        /* Check if the card is pulling dat[0:3] low */
        int     (*card_busy)(struct mmc_host *host);

which in case of sdhci-iproc is defined in sdhci.c:

static int sdhci_card_busy(struct mmc_host *mmc)
{
        struct sdhci_host *host = mmc_priv(mmc);
        u32 present_state;

        /* Check whether DAT[0] is 0 */
        present_state = sdhci_readl(host, SDHCI_PRESENT_STATE);

        return !(present_state & SDHCI_DATA_0_LVL_MASK);
}

I am just not sure if that is sufficient to deal with our wifi devices.
Maybe Franky can comment.

Regards,
Arend
