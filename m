Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:43169 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaIBI5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 04:57:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140902085436.GE6549@mwanda>
References: <20140901172729.GA6549@mwanda>
	<CAH6sp9NXUtOpagcaKOTJUH4m=2YcdeVoKDU4AHSvzyr+qcsFTA@mail.gmail.com>
	<20140902085436.GE6549@mwanda>
Date: Tue, 2 Sep 2014 10:57:49 +0200
Message-ID: <CAH6sp9Ocq5fhAsGZ0K-btXHmZ9fA85eju7bs+dr7y4Xp5ykPJQ@mail.gmail.com> (sfid-20140902_105755_417766_109FBC79)
Subject: Re: [patch -RESEND] NFC: potential overflows in microread_target_discovered()
From: Frans Klaver <fransklaver@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@ml01.01.org,
	kernel-janitors@vger.kernel.org, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 2, 2014 at 10:54 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Sep 02, 2014 at 09:02:36AM +0200, Frans Klaver wrote:
>> > diff --git a/drivers/nfc/microread/microread.c b/drivers/nfc/microread/microread.c
>> > index f868333271aa..963a4a5dc88e 100644
>> > --- a/drivers/nfc/microread/microread.c
>> > +++ b/drivers/nfc/microread/microread.c
>> > @@ -501,9 +501,13 @@ static void microread_target_discovered(struct nfc_hci_dev *hdev, u8 gate,
>> >                 targets->sens_res =
>> >                          be16_to_cpu(*(u16 *)&skb->data[MICROREAD_EMCF_A_ATQA]);
>> >                 targets->sel_res = skb->data[MICROREAD_EMCF_A_SAK];
>> > -               memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_A_UID],
>> > -                      skb->data[MICROREAD_EMCF_A_LEN]);
>> >                 targets->nfcid1_len = skb->data[MICROREAD_EMCF_A_LEN];
>> > +               if (targets->nfcid1_len > sizeof(targets->nfcid1)) {
>>
>> You should probably compare against sizeof(*targets->nfcid1).
>>
>
> No.  It's an array not a pointer.

Ai, I overlooked that one. My bad.
