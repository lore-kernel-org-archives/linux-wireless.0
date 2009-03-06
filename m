Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:44788 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZCFEMY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 23:12:24 -0500
Received: by qw-out-2122.google.com with SMTP id 5so385693qwi.37
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 20:12:21 -0800 (PST)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1236299085.6612.229.camel@rc-desk>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <c4d76b3b0901261913s23427b19tbbe34ee7b4261068@mail.gmail.com>
	 <c4d76b3b0901261935n1846b675w72cfa7308d198080@mail.gmail.com>
	 <20090127162437.GA3596@sortiz.org>
	 <c4d76b3b0901271531q19578871idbc59b5a23ac868e@mail.gmail.com>
	 <1ba2fa240901272312j270eedb5x33534a9703d26e06@mail.gmail.com>
	 <20090128113751.GA3197@sortiz.org>
	 <c4d76b3b0903011937p6538adbfpc0dab859a6742394@mail.gmail.com>
	 <1236141120.12734.2.camel@rainbow> <1236194370.6612.73.camel@rc-desk>
	 <c4d76b3b0903041147s2138e72bjb39864f87b4cd09e@mail.gmail.com>
	 <1236211493.6612.90.camel@rc-desk>  <1236297052.6153.4.camel@rainbow>
	 <1236299085.6612.229.camel@rc-desk>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 23:12:14 -0500
Message-Id: <1236312734.19328.37.camel@rainbow> (sfid-20090306_051228_433678_1CF182CA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-03-05 at 16:24 -0800, reinette chatre wrote:
> On Thu, 2009-03-05 at 15:50 -0800, Jason Andryuk wrote:
> > On Wed, 2009-03-04 at 16:04 -0800, reinette chatre wrote:
> > > On Wed, 2009-03-04 at 11:47 -0800, Jason Andryuk wrote:
> > > > On Wed, Mar 4, 2009 at 2:19 PM, reinette chatre
> > > > <reinette.chatre@intel.com> wrote:
> > > > > On Tue, 2009-03-03 at 20:32 -0800, Jason Andryuk wrote:
> > > > >> On Sun, Mar 1, 2009 at 10:37 PM, Jason Andryuk <jandryuk@gmail.com> wrote:
> > > > >> > I tested c2a0aa3cb733452e749727680e380dca6cc10a68 "iwl3945: use
> > > > >> > iwl_rb_status" with the additional patches to initialize rb_stts
> > > > >> > (copied from iwl_rx_queue_alloc) and to convert the BUG_ON to a
> > > > >> > WARN_ON.
> > > > >> >
> > > > >> > The driver runs without segfaulting.  So far the WARN_ON has not been
> > > > >> > triggered, but the driver fails to finish authentication with the AP.
> > > > >> > I receive "wlan0: authentication with AP 00:30:bd:c0:90:24 timed out"
> > > > >>
> > > > >> Ok, I started poking around with manually checking interesting commits instead of git bisect.
> > > > >>
> > > > >> 55b3e21... iwl3945: use iwl-io.h and delete iwl-3945-io.h with BUG->WARN patch works.
> > > > >>
> > > > >> bb64785... iwlwifi: use iwl_cmd instead of iwl3945_cmd
> > > > >> fails to authenticate to the AP.  It generates a Microcode SW Error attached below.
> > > > >>
> > > > >> The previous revision:
> > > > >> a0dedce... iwlwifi: replace IWL_ERROR with IWL_ERR
> > > > >> Authenticates to the AP and works just fine.
> > > > >>
> > > > >> I keep looking over commitdiff bb64785... but I cannot see what is causing problems.  I even tried modifying iwl3945_cmd in various ways from a0dedce... but those attempts kept working.
> > > > >>
> > > > >> During testing, I saw a lot of UNKNOWN 0x1b
> > > > >> [ 8892.625374] ieee80211 phy0: I iwl3945_rx_handle r = 162, i = 160, UNKNOWN, 0x1b
> > > > >> Currently in the logs for commit a0dedce... it shows up as REPLY_3945_RX.
> > > > >>
> > > > >> Any ideas?
> > > > >
> > > > > Thank you very much for this digging.
> > > > >
> > > > > Are you running on 64bit?
> > > >
> > > > Yes, 64bit.
> > >
> > > could you please try this patch on top of latest wireless-testing?
> > >
> > > Thanks
> > >
> > > Reinette
> > >
> > >
> > > diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> > > index 0a75053..00b25a8 100644
> > > --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> > > +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> > > @@ -743,6 +743,7 @@ void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
> > >       struct iwl3945_tfd *tfd_tmp = (struct iwl3945_tfd *)txq->tfds;
> > >       struct iwl3945_tfd *tfd = &tfd_tmp[txq->q.read_ptr];
> > >       struct pci_dev *dev = priv->pci_dev;
> > > +     int index = txq->q.read_ptr;
> > >       int i;
> > >       int counter;
> > >
> > > @@ -759,6 +760,13 @@ void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
> > >               return;
> > >       }
> > >
> > > +     /* Unmap tx_cmd */
> > > +     if (counter)
> > > +             pci_unmap_single(dev,
> > > +                             pci_unmap_addr(&txq->cmd[index]->meta, mapping),
> > > +                             pci_unmap_len(&txq->cmd[index]->meta, len),
> > > +                             PCI_DMA_TODEVICE);
> > > +
> > >       /* unmap chunks if any */
> > >
> > >       for (i = 1; i < counter; i++) {
> > 
> > Reinette,
> > 
> > I applied the patch, but iwl3945 did not authenticate with my AP
> > 
> 
> oh no.
> 
> I will install a 64bit system here to try and reproduce this ...
> 
> Reinette

I created the patch below, made of the iwl_host_cmd and iwl_meta_cmd
portions of commit "bb64785... iwlwifi: use iwl_cmd instead of
iwl3945_cmd".  Applied to "a0dedce... iwlwifi: replace IWL_ERROR with
IWL_ERR", I am able to connect and transfer data successfully.  There
are three warning during compilation (type mismatch with
cmd.meta.u.callback).

So something with the remainder of the iwl_cmd conversion is wrong.  Are
there alignment restrictions for the ucode?

Thanks for looking into this.

Jason

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index 958e705..0cdfea7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -83,7 +83,7 @@ static inline int iwl3945_brightness_to_idx(enum led_brightness brightness)
 static int iwl_send_led_cmd(struct iwl_priv *priv,
 			    struct iwl_led_cmd *led_cmd)
 {
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_LEDS_CMD,
 		.len = sizeof(struct iwl_led_cmd),
 		.data = led_cmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 63bf832..9aeee87 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -147,23 +147,8 @@ struct iwl3945_frame {
 #define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
 #define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
 
-struct iwl3945_cmd;
 struct iwl_priv;
 
-struct iwl3945_cmd_meta {
-	struct iwl3945_cmd_meta *source;
-	union {
-		struct sk_buff *skb;
-		int (*callback)(struct iwl_priv *priv,
-				struct iwl3945_cmd *cmd, struct sk_buff *skb);
-	} __attribute__ ((packed)) u;
-
-	/* The CMD_SIZE_HUGE flag bit indicates that the command
-	 * structure is stored at the end of the shared queue memory. */
-	u32 flags;
-
-} __attribute__ ((packed));
-
 /**
  * struct iwl3945_cmd
  *
@@ -172,7 +157,7 @@ struct iwl3945_cmd_meta {
  * (which is relatively huge; space is allocated separately).
  */
 struct iwl3945_cmd {
-	struct iwl3945_cmd_meta meta;
+	struct iwl_cmd_meta meta;
 	struct iwl_cmd_header hdr;
 	union {
 		struct iwl3945_addsta_cmd addsta;
@@ -193,15 +178,8 @@ struct iwl3945_cmd {
 	} __attribute__ ((packed)) cmd;
 } __attribute__ ((packed));
 
-struct iwl3945_host_cmd {
-	u8 id;
-	u16 len;
-	struct iwl3945_cmd_meta meta;
-	const void *data;
-};
-
 #define TFD39_MAX_PAYLOAD_SIZE (sizeof(struct iwl3945_cmd) - \
-			      sizeof(struct iwl3945_cmd_meta))
+			      sizeof(struct iwl_cmd_meta))
 
 /*
  * RX related structures and functions
@@ -288,7 +266,7 @@ extern void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl3945_tx_queue
 extern int iwl3945_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
 			    const void *data);
 extern int __must_check iwl3945_send_cmd(struct iwl_priv *priv,
-		struct iwl3945_host_cmd *cmd);
+		struct iwl_host_cmd *cmd);
 extern unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,int left);
 extern int iwl3945_rx_queue_update_write_ptr(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d84c4ce..7b216e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -501,7 +501,7 @@ static inline int iwl3945_is_ready_rf(struct iwl_priv *priv)
  * failed. On success, it turns the index (> 0) of command in the
  * command queue.
  */
-static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl3945_host_cmd *cmd)
+static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	struct iwl3945_tx_queue *txq = &priv->txq39[IWL_CMD_QUEUE_NUM];
 	struct iwl_queue *q = &txq->q;
@@ -580,7 +580,7 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl3945_host_cmd *
 	return ret ? ret : idx;
 }
 
-static int iwl3945_send_cmd_async(struct iwl_priv *priv, struct iwl3945_host_cmd *cmd)
+static int iwl3945_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	int ret;
 
@@ -605,7 +605,7 @@ static int iwl3945_send_cmd_async(struct iwl_priv *priv, struct iwl3945_host_cmd
 	return 0;
 }
 
-static int iwl3945_send_cmd_sync(struct iwl_priv *priv, struct iwl3945_host_cmd *cmd)
+static int iwl3945_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	int cmd_idx;
 	int ret;
@@ -695,7 +695,7 @@ out:
 	return ret;
 }
 
-int iwl3945_send_cmd(struct iwl_priv *priv, struct iwl3945_host_cmd *cmd)
+int iwl3945_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	if (cmd->meta.flags & CMD_ASYNC)
 		return iwl3945_send_cmd_async(priv, cmd);
@@ -705,7 +705,7 @@ int iwl3945_send_cmd(struct iwl_priv *priv, struct iwl3945_host_cmd *cmd)
 
 int iwl3945_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len, const void *data)
 {
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = id,
 		.len = len,
 		.data = data,
@@ -716,7 +716,7 @@ int iwl3945_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len, const void *data
 
 static int __must_check iwl3945_send_cmd_u32(struct iwl_priv *priv, u8 id, u32 val)
 {
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = id,
 		.len = sizeof(val),
 		.data = &val,
@@ -895,7 +895,7 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 	int rc = 0;
 	struct iwl_rx_packet *res = NULL;
 	struct iwl3945_rxon_assoc_cmd rxon_assoc;
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_RXON_ASSOC,
 		.len = sizeof(rxon_assoc),
 		.meta.flags = CMD_WANT_SKB,
@@ -1079,7 +1079,7 @@ static int iwl3945_send_scan_abort(struct iwl_priv *priv)
 {
 	int rc = 0;
 	struct iwl_rx_packet *res;
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_ABORT_CMD,
 		.meta.flags = CMD_WANT_SKB,
 	};
@@ -1135,7 +1135,7 @@ static int iwl3945_card_state_sync_callback(struct iwl_priv *priv,
  */
 static int iwl3945_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_flag)
 {
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_CARD_STATE_CMD,
 		.len = sizeof(u32),
 		.data = &flags,
@@ -1181,7 +1181,7 @@ int iwl3945_send_add_station(struct iwl_priv *priv,
 {
 	struct iwl_rx_packet *res = NULL;
 	int rc = 0;
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_ADD_STA,
 		.len = sizeof(struct iwl3945_addsta_cmd),
 		.meta.flags = flags,
@@ -2799,7 +2799,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 {
 	struct iwl_spectrum_cmd spectrum;
 	struct iwl_rx_packet *res;
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_SPECTRUM_MEASUREMENT_CMD,
 		.data = (void *)&spectrum,
 		.meta.flags = CMD_WANT_SKB,
@@ -5984,7 +5984,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 {
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, request_scan);
-	struct iwl3945_host_cmd cmd = {
+	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
 		.len = sizeof(struct iwl3945_scan_cmd),
 		.meta.flags = CMD_SIZE_HUGE,

