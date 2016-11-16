Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35195 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752375AbcKPO3M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 09:29:12 -0500
Received: by mail-wm0-f43.google.com with SMTP id a197so243017359wmd.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2016 06:29:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <33589cf2-a7e6-fe9a-ea2b-a2252ac00355@gmail.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
 <1479141222-8493-4-git-send-email-erik.stromdahl@gmail.com>
 <CA+BoTQmA0E+N46E3XkpqVPXSVkQNyZj2Qzrizk8iLdYzVthNQg@mail.gmail.com> <33589cf2-a7e6-fe9a-ea2b-a2252ac00355@gmail.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Wed, 16 Nov 2016 15:29:09 +0100
Message-ID: <CA+BoTQ=vpdHYHdE2UCcY4jCOcMqXEMSaKQUXekF7O+H9dWuREQ@mail.gmail.com> (sfid-20161116_152916_111136_92C0442E)
Subject: Re: [RFC 03/12] ath10k: htc: Changed order of wait target and ep connect
To: Erik Stromdahl <erik.stromdahl@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 November 2016 at 18:07, Erik Stromdahl <erik.stromdahl@gmail.com> wro=
te:
> On 11/15/2016 11:13 AM, Michal Kazior wrote:
>> On 14 November 2016 at 17:33, Erik Stromdahl <erik.stromdahl@gmail.com> =
wrote:
>>> This patch changes the order in which the driver waits for the
>>> target to become ready and the service connect of the HTC
>>> control service.
>>>
>>> The HTC control service is connected before the driver starts
>>> waiting for the HTC ready control message.
>>>
>>> The reason for this is that the HTC ready control message is
>>> transmitted on EP 0 and that sdio/mbox based systems will ignore
>>> messages received on unconnected endpoints.
>>>
>>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>>> ---
>>>  drivers/net/wireless/ath/ath10k/htc.c |   32 ++++++++++++++++---------=
-------
>>>  1 file changed, 16 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wirele=
ss/ath/ath10k/htc.c
>>> index e3f7bf4..7257366 100644
>>> --- a/drivers/net/wireless/ath/ath10k/htc.c
>>> +++ b/drivers/net/wireless/ath/ath10k/htc.c
>>> @@ -606,6 +606,22 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
>>>         u16 credit_count;
>>>         u16 credit_size;
>>>
>>> +       /* setup our pseudo HTC control endpoint connection */
>>> +       memset(&conn_req, 0, sizeof(conn_req));
>>> +       memset(&conn_resp, 0, sizeof(conn_resp));
>>> +       conn_req.ep_ops.ep_tx_complete =3D ath10k_htc_control_tx_comple=
te;
>>> +       conn_req.ep_ops.ep_rx_complete =3D ath10k_htc_control_rx_comple=
te;
>>> +       conn_req.max_send_queue_depth =3D ATH10K_NUM_CONTROL_TX_BUFFERS=
;
>>> +       conn_req.service_id =3D ATH10K_HTC_SVC_ID_RSVD_CTRL;
>>> +
>>> +       /* connect fake service */
>>> +       status =3D ath10k_htc_connect_service(htc, &conn_req, &conn_res=
p);
>>> +       if (status) {
>>> +               ath10k_err(ar, "could not connect to htc service (%d)\n=
",
>>> +                          status);
>>> +               return status;
>>> +       }
>>> +
>>
>> How is this supposed to work? ath10k_htc_connect_service() requires
>> htc->target_credit_size to compute tx_credits_per_max_message. Or am I
>> missing something? Applying this patch alone results in:
>>
>> [    6.680101] divide error: 0000 [#1] SMP
>> [    6.681342] Modules linked in: ath10k_pci(O) ath10k_core(O) ath
>> mac80211 cfg80211
>> [    6.684876] CPU: 3 PID: 823 Comm: kworker/u8:2 Tainted: G        W
>> O    4.9.0-rc4-wt-ath+ #79
>> [    6.688051] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>> BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
>> [    6.691644] Workqueue: ath10k_wq ath10k_core_register_work [ath10k_co=
re]
>> [    6.694309] task: ffff88000a190000 task.stack: ffffc900006d4000
>> [    6.695458] RIP: 0010:[<ffffffffa01ae46b>]  [<ffffffffa01ae46b>]
>> ath10k_htc_connect_service+0x21b/0x420 [ath10k_core]
>>
>>
>> Micha=C5=82
>>
>
> You're right. I have totally missed this. What is strange is that my
> compiler (ARM linaro) seems to optimize the code in a way that removes
> the tx_credits_per_max_message value.
>
> If I add a printk in ath10k_htc_connect_service (printing the value) I
> get a similar oops.
>
> I think it has to do with the fact the this value isn't really used at
> all. grepping the code reveals that tx_credits_per_max_message is only
> used inside ath10k_htc_connect_service (only written, never read).
>
> Removing it doesn't seem to break anything, so perhaps it should be remov=
ed?

I think it's safe to remove now. This is legacy inherited from the
internal driver.

Otherwise this looks okay except commit log which is a bit unclear.
I'm still not sure *why* you need to reorder this. FWIW this can be a
general clean up thing that ends up moving the if (eid =3D=3D EP0) {code}
to control endpoint handler in patch 4.


Micha=C5=82
