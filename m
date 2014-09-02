Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34463 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaIBIzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 04:55:36 -0400
Date: Tue, 2 Sep 2014 11:54:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@ml01.01.org,
	kernel-janitors@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [patch -RESEND] NFC: potential overflows in
 microread_target_discovered()
Message-ID: <20140902085436.GE6549@mwanda> (sfid-20140902_105541_851008_4326CB4A)
References: <20140901172729.GA6549@mwanda>
 <CAH6sp9NXUtOpagcaKOTJUH4m=2YcdeVoKDU4AHSvzyr+qcsFTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH6sp9NXUtOpagcaKOTJUH4m=2YcdeVoKDU4AHSvzyr+qcsFTA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 02, 2014 at 09:02:36AM +0200, Frans Klaver wrote:
> > diff --git a/drivers/nfc/microread/microread.c b/drivers/nfc/microread/microread.c
> > index f868333271aa..963a4a5dc88e 100644
> > --- a/drivers/nfc/microread/microread.c
> > +++ b/drivers/nfc/microread/microread.c
> > @@ -501,9 +501,13 @@ static void microread_target_discovered(struct nfc_hci_dev *hdev, u8 gate,
> >                 targets->sens_res =
> >                          be16_to_cpu(*(u16 *)&skb->data[MICROREAD_EMCF_A_ATQA]);
> >                 targets->sel_res = skb->data[MICROREAD_EMCF_A_SAK];
> > -               memcpy(targets->nfcid1, &skb->data[MICROREAD_EMCF_A_UID],
> > -                      skb->data[MICROREAD_EMCF_A_LEN]);
> >                 targets->nfcid1_len = skb->data[MICROREAD_EMCF_A_LEN];
> > +               if (targets->nfcid1_len > sizeof(targets->nfcid1)) {
> 
> You should probably compare against sizeof(*targets->nfcid1).
> 

No.  It's an array not a pointer.

You should make a small test program to test your ideas.

int main(void)
{
        char buf[10];

        printf("%d %d\n", sizeof(buf), sizeof(*buf));
        return 0;
}

regards,
dan carpenter

