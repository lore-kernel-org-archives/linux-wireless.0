Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f167.google.com ([209.85.217.167]:45087 "EHLO
	mail-gx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZCJNSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 09:18:52 -0400
Received: by gxk11 with SMTP id 11so870990gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 06:18:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1236661466.15923.53.camel@rc-desk>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <1236194370.6612.73.camel@rc-desk>
	 <c4d76b3b0903041147s2138e72bjb39864f87b4cd09e@mail.gmail.com>
	 <1236211493.6612.90.camel@rc-desk> <1236297052.6153.4.camel@rainbow>
	 <1236299085.6612.229.camel@rc-desk>
	 <1236312734.19328.37.camel@rainbow> <1236317982.12430.9.camel@rc-desk>
	 <1236649234.6685.9.camel@rainbow> <1236661466.15923.53.camel@rc-desk>
Date: Tue, 10 Mar 2009 09:10:39 -0400
Message-ID: <c4d76b3b0903100610v21da8728l1414ca0187f29376@mail.gmail.com> (sfid-20090310_141856_860317_FC3CE99A)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I am finding it hard to keep track of things as what works and what d=
oes
> not work appears to shift. I did install a 64bit system in the hopes =
of
> reproducing your issue but could not with a basic open connect. How d=
o
> you connect to the AP? Please provide details that you think will ena=
ble
> me to reproduce.

I am trying to connect to an unencrypted 802.11b AP.

Back in January, after first encountering the BUG, I attempted a git
bisect, but I ran into problems.

=46rom earlier git bisect attempts, I found commit
"738910c064ff461051cd37e17199f270ff88a9a3 iwl3945: use rx queue
management infrastructure from iwlcore" is the first to trigger the
original BUG_ON.

"commit cbd8b90ffd8a321ffb2a705733729f0d5ebb20f9 iwl3945:
iwl3945_queue and iwl3945_channel_info replacement" worked
successfully.

Unfortunately, the conversion of iwl3945 leaves the driver inoperable
at many places between the two commits above, so a bisect fails on
account of other issues.  I have been spending time progressing from
cbd8b90f... to 738910c0... and fixing issues as encountered.
=46ollowing the commits on this page,
http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-testing.g=
it;a=3Dshortlog;h=3D738910c064ff461051cd37e17199f270ff88a9a3
, I am trying to get from "cbd8b90ffd8a321ffb2a705733729f0d5ebb20f9
iwl3945: iwl3945_queue and iwl3945_channel_info replacement" to the
top.

While doing that, I have to fix errors to get the driver functional.

Basically, I am doing a manual bisect where I have to fix the errors
at each stage.  But it isn't truly a bisect as I am progressing from
cbd8b90f... to 738910c0...

On Tue, Mar 10, 2009 at 1:04 AM, reinette chatre
<reinette.chatre@intel.com> wrote:
> Hi Jason,
>
> On Mon, 2009-03-09 at 18:40 -0700, Jason Andryuk wrote:
>> I thought I had made a big breakthrough when I found the solution to
>> getting
>> "iwlwifi: use iwl_cmd instead of iwl3945_cmd"
>> bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d to work. =A0Then I discover=
ed
>> that casting to iwl3945_tx_cmd was fixed later by "iwl3945: use
>> iwl3945_tx_cmd instead of iwl_tx_cmd" fadd267e...
>
>
> Does this mean if you apply commit fadd267e on top of
> bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d then things work?

No.  My patch, which is basically fadd267e..., completes the
transition of bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d and allows the
driver to work at *that* stage.
bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d and fadd267e should have been
one commit.

>>
>> However, with this new knowledge, I was able to get farther.
>>
>> Using my iwl3945_tx_cmd conversion patch,
>
> Is this the last patch you emailed?

I don't have the patch in front of me, but it is basically fadd267e

>> a patch for allocating rb_stts

It is basically the reverse of this patch from Sam Ortiz *I think*.
Again, I don't have it in front of me.  Commit "
c2a0aa3cb733452e749727680e380dca6cc10a68 iwl3945: use iwl_rb_status"
has a NULL pointer dereference since it doesn't allocate rb_stts.

---
 drivers/net/wireless/iwlwifi/iwl-rx.c |    8 --------
 1 file changed, 8 deletions(-)

Index: wireless-testing/drivers/net/wireless/iwlwifi/iwl-rx.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-rx.c
2009-01-27 17:13:46.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-rx.c
2009-01-27 17:15:46.000000000 +0100
@@ -346,11 +346,6 @@ int iwl_rx_queue_alloc(struct iwl_priv *
       if (!rxq->bd)
               goto err_bd;

-       rxq->rb_stts =3D pci_alloc_consistent(dev, sizeof(struct iwl_rb=
_status),
-                                       &rxq->rb_stts_dma);
-       if (!rxq->rb_stts)
-               goto err_rb;
-
       /* Fill the rx_used queue with _all_ of the Rx buffers */
       for (i =3D 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
               list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
@@ -362,9 +357,6 @@ int iwl_rx_queue_alloc(struct iwl_priv *
       rxq->need_update =3D 0;
       return 0;

-err_rb:
-       pci_free_consistent(priv->pci_dev, 4 * RX_QUEUE_SIZE, rxq->bd,
-                           rxq->dma_addr);
 err_bd:
       return -ENOMEM;
 }

>> and a patch for the BUG_ON -> WARN_ON,
>
> ... and this one

This is your patch from January 9

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a23d51d..09c1c8d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3118,7 +3118,14 @@ static void iwl3945_tx_cmd_complete(struct
iwl_priv *priv,
 	int cmd_index;
 	struct iwl_cmd *cmd;

-	BUG_ON(txq_id !=3D IWL_CMD_QUEUE_NUM);
+	if (WARN(txq_id !=3D IWL_CMD_QUEUE_NUM,
+		 "wrong command queue %d, sequence 0x%X readp=3D%d writep=3D%d\n",
+		  txq_id, sequence,
+		  priv->txq[IWL_CMD_QUEUE_NUM].q.read_ptr,
+		  priv->txq[IWL_CMD_QUEUE_NUM].q.write_ptr)) {
+		iwl_print_hex_dump(priv, IWL_DL_INFO , rxb, 32);
+		return;
+	}

 	cmd_index =3D get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, h=
uge);
 	cmd =3D priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];


>> =A0I was able to narrow down commit
>> "iwl3945: sync tx queue data structure with iwlagn"
>> ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f as the one that starts
>> introducing Microcode SW errors.
>>
>
> I am not sure how your repository looks at this stage. What is your
> latest wireless-testing commit and what patches do you have on top of
> it?

The repo looks like this:
git checkout -f ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f
patch -p1 < ../iwl-tx-cmd-conversion.patch
patch -p1 < ../iwl-rb_stts.patch
patch -p1 < ../iwl-BUG-to-WARN.patch

The previous commit with the above patches works.

>> I tried adding in Reinette's iwl3945_hw_txq_free_tfd pci_unmap_singl=
e
>> patch from earlier, but it did not fix the problem.
>>
>> Would TX debugging output be more helpful?
>
> You log below has a new error (similar to what you note in your next
> email). "Unsupported interface type 515". This is very strange and
> really looks like some corruption as this value is initialized with a
> macro during probe. Could you enable mac and info debugging also (add
> 0x3 to your current debug flags)? This code has also changed a bit si=
nce
> commit bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d.
>
> You can also put a dump_stack() in iwl3945_connection_init_rx_config =
to
> see where the call comes from and then trace the value of mode to see
> where it is set to 515 ... it is supposed to be 2
> (NL80211_IFTYPE_STATION).

It may be a little while before I can get back to this.

Thanks for looking into it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
