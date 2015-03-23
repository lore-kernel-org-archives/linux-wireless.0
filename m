Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:33020 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbbCWJqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 05:46:53 -0400
Received: by labto5 with SMTP id to5so21795104lab.0
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2015 02:46:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADnKcVhZah4it3EQWrj6ZKb7vYZ6S3-FtNzPZs6_05GBAQtkvA@mail.gmail.com>
References: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
 <1426849379-7562-6-git-send-email-marek.puzyniak@tieto.com>
 <CA+XVXfdsHo4cm580oqCwd9SZQGrdkPgw_b+ipUVCDhkDupL0tw@mail.gmail.com>
 <CA+BoTQ=fcbYokNgrmLpjgPPpUXkP02QQQRN-Y52CHwrY1+JHJA@mail.gmail.com> <CADnKcVhZah4it3EQWrj6ZKb7vYZ6S3-FtNzPZs6_05GBAQtkvA@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 23 Mar 2015 11:46:36 +0200
Message-ID: <CA+XVXff=ExovNTovdVP9Hw58HFhx_cRg4ijsp7ETz7b5eAY4Gg@mail.gmail.com> (sfid-20150323_104700_058671_CD14EFE2)
Subject: Re: [PATCH v4 5/6] ath10k: add wmi support for tdls
To: Marek Puzyniak <marek.puzyniak@tieto.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 23, 2015 at 10:59 AM, Marek Puzyniak
<marek.puzyniak@tieto.com> wrote:
> On 23 March 2015 at 09:09, Michal Kazior <michal.kazior@tieto.com> wrote:
>> On 22 March 2015 at 08:49, Arik Nemtsov <arik@wizery.com> wrote:
>>> On Fri, Mar 20, 2015 at 1:02 PM, Marek Puzyniak
>>> <marek.puzyniak@tieto.com> wrote:
>>>> As a part of tdls implementation introduce
>>>> tdls related wmi data structures, constant
>>>> values and functions.
>>>>
>>>> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
>>>> ---
>>>>  drivers/net/wireless/ath/ath10k/wmi-ops.h |  42 ++++++++
>>>>  drivers/net/wireless/ath/ath10k/wmi-tlv.c | 153 ++++++++++++++++++++++++++++++
>>>>  drivers/net/wireless/ath/ath10k/wmi-tlv.h |  53 +++++++++++
>>>>  drivers/net/wireless/ath/ath10k/wmi.h     |  37 ++++++++
>>>>  4 files changed, 285 insertions(+)
>>> [...]
>>>> +
>>>> +       cmd = (void *)tlv->value;
>>>> +       cmd->vdev_id = __cpu_to_le32(vdev_id);
>>>> +       cmd->state = __cpu_to_le32(state);
>>>> +       cmd->notification_interval_ms = __cpu_to_le32(5000);
>>>> +       cmd->tx_discovery_threshold = __cpu_to_le32(100);
>>>> +       cmd->tx_teardown_threshold = __cpu_to_le32(5);
>>>> +       cmd->rssi_teardown_threshold = __cpu_to_le32(-75);
>>>> +       cmd->rssi_delta = __cpu_to_le32(-20);
>>>> +       cmd->tdls_options = __cpu_to_le32(options);
>>>> +       cmd->tdls_peer_traffic_ind_window = __cpu_to_le32(2);
>>>> +       cmd->tdls_peer_traffic_response_timeout_ms = __cpu_to_le32(5000);
>>>> +       cmd->tdls_puapsd_mask = __cpu_to_le32(0xf);
>>>> +       cmd->tdls_puapsd_inactivity_time_ms = __cpu_to_le32(0);
>>>> +       cmd->tdls_puapsd_rx_frame_threshold = __cpu_to_le32(10);
>>>
>>> Do the above lines assume all TDLS peers support TDLS buffer-sta
>>> (which is required for peer UAPSD)? Especially the value of
>>> tdls_puapsd_mask.
>
> No. The function you reffer to configures device itself not TDLS
> peers. Currently tdls peer uapsd buffer sta is not implemented as
> Michał wrote.

If the device configures UAPSD queues for itself, then it requires
buffer-sta support from its peer, not from itself.
But you've reassured me you don't require this from the peer, as it
would hurt ath10k vs. ath10k TDLS connections.

Arik
