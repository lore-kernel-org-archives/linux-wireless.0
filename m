Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52596 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753792AbeDVO3F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Apr 2018 10:29:05 -0400
From: "Dedy Lansky" <dlansky@codeaurora.org>
To: "'David Dean Zhang'" <daviddean166@gmail.com>,
        <linux-wireless@vger.kernel.org>
References: <CAFnQ7os8AQGwJfkunZG-x9f9jdnOw=tjGCHE9wNxNwLfqka_tQ@mail.gmail.com> <001901d3c759$8cd5b970$a6812c50$@codeaurora.org> <CAFnQ7oti-cKJxBXyuCCfJeLgHMcw1U0pE1hkdCH_ukN032f90A@mail.gmail.com>
In-Reply-To: <CAFnQ7oti-cKJxBXyuCCfJeLgHMcw1U0pE1hkdCH_ukN032f90A@mail.gmail.com>
Subject: RE: wil6210: low level sector API
Date: Sun, 22 Apr 2018 17:29:01 +0300
Message-ID: <000e01d3da46$43f06430$cbd12c90$@codeaurora.org> (sfid-20180422_162914_934835_700B6E16)
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: linux-wireless-owner@vger.kernel.org =
[mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of David Dean =
Zhang
> Sent: Wednesday, April 18, 2018 9:01 PM

> I updated the firmware and tried to call some low level functions, =
like WMI_PRIO_TX_SECTORS_NUMBER_CMDID and WMI_SET_RF_SECTOR_ON_CMDID .
> The previous errors have gone but it still has errors:
> wil6210 0000:03:00.0 wlp3s0: wmi_event_handle: Unhandled event 0x19a5
> wil6210 0000:03:00.0 wlp3s0: wmi_call: wmi_call(0x09a6->0x19a6) =
timeout 2000 msec
> So I am wondering whether it is because the chipset does not support =
these wmi commands. I just want to know how to use these commands and =
how to disable TXSS. I appreciate if anyone could provide some =
suggestions. Thanks.

This is a bug in FW that upon WMI_PRIO_TX_SECTORS_NUMBER_CMDID, wrong =
event is returned. Most likely that the WMI_PRIO_TX_SECTORS_NUMBER_CMDID =
was handled successfully. The bug is not critical - event 0x19a5 is =
returned instead of 0x19a6 (as can be seen in dmesg).

Another option for disabling TXSS/BRP and hopefully to keep the sector =
locked is by using WMI_BF_CONTROL_CMDID. Setting "triggers" and =
"long_term_enable" to 0 should disable BF completely.

Thanks,
 Dedy.
