Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:34165 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1KAIuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 04:50:17 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: Gustavo Padovan <padovan@profusion.mobi>
CC: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 1 Nov 2011 09:49:44 +0100
Subject: RE: [PATCH v2] NFC: update to NCI spec 1.0 draft 18
Message-ID: <AC090B9732AB2B4DB7FF476E907FE660013BAEC736@dnce02.ent.ti.com> (sfid-20111101_095023_571423_902A878A)
References: <1319551485-17963-1-git-send-email-ilane@ti.com>
 <20111031155151.GA9177@joana>
In-Reply-To: <20111031155151.GA9177@joana>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Hi Gustavo,

Thanks for your comments.

> > -struct nci_rf_activate_ntf {
> > -	__u8	target_handle;
> > +struct nci_rf_intf_activated_ntf {
> > +	__u8	rf_discovery_id;
> > +	__u8	rf_interface_type;
> >  	__u8	rf_protocol;
> > -	__u8	rf_tech_and_mode;
> > +	__u8	activation_rf_tech_and_mode;
> >  	__u8	rf_tech_specific_params_len;
> >  
> >  	union {
> >  		struct rf_tech_specific_params_nfca_poll nfca_poll;
> >  	} rf_tech_specific_params;
> >  
> > -	__u8	rf_interface_type;
> > +	__u8	data_exchange_rf_tech_and_mode;
> > +	__u8	data_exchange_tx_bit_rate;
> > +	__u8	data_exchange_rx_bit_rate;
> >  	__u8	activation_params_len;
> 
> Aren't these names too big? Do you really need such a big names?
I made all the names exactly as stated in the NCI spec, to make it as clear as possible.
I'll try to shorten the big ones :-)

> >  
> >  	union {
> > @@ -309,5 +309,9 @@ struct nci_rf_activate_ntf {
> >  } __packed;
> >  
> >  #define NCI_OP_RF_DEACTIVATE_NTF	
> nci_opcode_pack(NCI_GID_RF_MGMT, 0x06)
> > +struct nci_rf_deactivate_ntf {
> > +	__u8	type;
> > +	__u8	reason;
> > +} __packed;
> 
> What about a patch that only change the defines? Could make 
> things easier to
> review.
Sure, I'll split the patch into a series of patches for NCI draft 18.

> > @@ -725,7 +722,9 @@ static void nci_tx_work(struct 
> work_struct *work)
> >  		if (!skb)
> >  			return;
> >  
> > -		atomic_dec(&ndev->credits_cnt);
> > +		/* Check if data flow control is used */
> > +		if (atomic_read(&ndev->credits_cnt) != 0xff)
> > +			atomic_dec(&ndev->credits_cnt);
> 
> This seems racy to me. Can't the value of credits_cnt change 
> in between of
> atomic_read and atomic_dec?
The value 0xFF is only used to indicate that flow control is disabled.
Therefore, the condition is only used to check if flow control is enabled, and in this case we're allowed to change it.
The decision if flow control is enabled or disabled is taken only during init phase and remains constant.

> > -static void nci_rf_activate_ntf_packet(struct nci_dev *ndev,
> > -					struct sk_buff *skb)
> > +static void nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
> > +						struct sk_buff *skb)
> >  {
> > -	struct nci_rf_activate_ntf ntf;
> > +	struct nci_rf_intf_activated_ntf ntf;
> >  	__u8 *data = skb->data;
> > -	int rc = -1;
> > +	int err = 0;
> >  
> >  	clear_bit(NCI_DISCOVERY, &ndev->flags);
> >  	set_bit(NCI_POLL_ACTIVE, &ndev->flags);
> >  
> > -	ntf.target_handle = *data++;
> > +	ntf.rf_discovery_id = *data++;
> > +	ntf.rf_interface_type = *data++;
> >  	ntf.rf_protocol = *data++;
> > -	ntf.rf_tech_and_mode = *data++;
> > +	ntf.activation_rf_tech_and_mode = *data++;
> >  	ntf.rf_tech_specific_params_len = *data++;
> >  
> > -	nfc_dbg("target_handle %d, rf_protocol 0x%x, 
> rf_tech_and_mode 0x%x, rf_tech_specific_params_len %d",
> > -		ntf.target_handle,
> > -		ntf.rf_protocol,
> > -		ntf.rf_tech_and_mode,
> > +	nfc_dbg("rf_discovery_id %d", ntf.rf_discovery_id);
> > +	nfc_dbg("rf_interface_type 0x%x", ntf.rf_interface_type);
> > +	nfc_dbg("rf_protocol 0x%x", ntf.rf_protocol);
> > +	nfc_dbg("activation_rf_tech_and_mode 0x%x",
> > +		ntf.activation_rf_tech_and_mode);
> > +	nfc_dbg("rf_tech_specific_params_len %d",
> >  		ntf.rf_tech_specific_params_len);
> >  
> > -	switch (ntf.rf_tech_and_mode) {
> > -	case NCI_NFC_A_PASSIVE_POLL_MODE:
> > -		rc = nci_rf_activate_nfca_passive_poll(ndev, &ntf,
> > -			data);
> > -		break;
> > +	if (ntf.rf_tech_specific_params_len > 0) {
> > +		switch (ntf.activation_rf_tech_and_mode) {
> > +		case NCI_NFC_A_PASSIVE_POLL_MODE:
> > +			data = 
> nci_extract_rf_params_nfca_passive_poll(ndev,
> > +				&ntf, data);
> > +			break;
> > +
> > +		default:
> > +			nfc_err("unsupported 
> activation_rf_tech_and_mode 0x%x",
> > +				ntf.activation_rf_tech_and_mode);
> > +			return;
> > +		}
> > +	}
> >  
> > -	default:
> > -		nfc_err("unsupported rf_tech_and_mode 0x%x",
> > -			ntf.rf_tech_and_mode);
> > -		return;
> > +	ntf.data_exchange_rf_tech_and_mode = *data++;
> > +	ntf.data_exchange_tx_bit_rate = *data++;
> > +	ntf.data_exchange_rx_bit_rate = *data++;
> > +	ntf.activation_params_len = *data++;
> > +
> > +	nfc_dbg("data_exchange_rf_tech_and_mode 0x%x",
> > +		ntf.data_exchange_rf_tech_and_mode);
> > +	nfc_dbg("data_exchange_tx_bit_rate 0x%x",
> > +		ntf.data_exchange_tx_bit_rate);
> > +	nfc_dbg("data_exchange_rx_bit_rate 0x%x",
> > +		ntf.data_exchange_rx_bit_rate);
> > +	nfc_dbg("activation_params_len %d",
> > +		ntf.activation_params_len);
> > +
> > +	if (ntf.activation_params_len > 0) {
> 
> Seems to me that ntf.activation_params_len > 0 can be a check 
> in the beginning
> of this function.
Actually, each param is read in order (as you can see the pointer data is advanced on each param read).
The order is important, since it's clearer and some parameters are depend on the previous ones (e.g. we must read activation_rf_tech_and_mode before we read the activation params).
So, activation_params_len is read when we arrive to its location in the data stream.
In any case, I don't see the benefit in checking the condition in the beginning of the function (since I still need to read the other params).
 
> > @@ -57,86 +58,76 @@ static void 
> nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
> >  
> >  	nfc_dbg("entry, status 0x%x", rsp_1->status);
> >  
> > -	if (rsp_1->status != NCI_STATUS_OK)
> > -		return;
> > -
> > -	ndev->nfcc_features = __le32_to_cpu(rsp_1->nfcc_features);
> > -	ndev->num_supported_rf_interfaces = 
> rsp_1->num_supported_rf_interfaces;
> > -
> > -	if (ndev->num_supported_rf_interfaces >
> > -		NCI_MAX_SUPPORTED_RF_INTERFACES) {
> > +	if (rsp_1->status == NCI_STATUS_OK) {
> 
> This works better if you invert the check and add a "goto 
> err", then you save
> one indentation level in the code.
OK, I'll do it.
 
> > +		ndev->nfcc_features = 
> __le32_to_cpu(rsp_1->nfcc_features);
> >  		ndev->num_supported_rf_interfaces =
> > -			NCI_MAX_SUPPORTED_RF_INTERFACES;
> > +			rsp_1->num_supported_rf_interfaces;
> > +
> > +		if (ndev->num_supported_rf_interfaces >
> > +			NCI_MAX_SUPPORTED_RF_INTERFACES) {
> 
> Wrong indentation, one more tab here.
OK, I'll fix it.
  
> > -static void nci_core_conn_create_rsp_packet(struct nci_dev *ndev,
> > -						struct sk_buff *skb)
> > -{
> > -	struct nci_core_conn_create_rsp *rsp = (void *) skb->data;
> > -
> > -	nfc_dbg("entry, status 0x%x", rsp->status);
> > -
> > -	if (rsp->status != NCI_STATUS_OK)
> > -		return;
> > -
> > -	ndev->max_pkt_payload_size = rsp->max_pkt_payload_size;
> > -	ndev->initial_num_credits = rsp->initial_num_credits;
> > -	ndev->conn_id = rsp->conn_id;
> > -
> > -	atomic_set(&ndev->credits_cnt, ndev->initial_num_credits);
> > -
> > -	nfc_dbg("max_pkt_payload_size %d", ndev->max_pkt_payload_size);
> > -	nfc_dbg("initial_num_credits %d", ndev->initial_num_credits);
> > -	nfc_dbg("conn_id %d", ndev->conn_id);
> > -}
> > -
> >  static void nci_rf_disc_map_rsp_packet(struct nci_dev *ndev,
> >  					struct sk_buff *skb)
> >  {
> > @@ -196,10 +187,6 @@ void nci_rsp_packet(struct nci_dev 
> *ndev, struct sk_buff *skb)
> >  		nci_core_init_rsp_packet(ndev, skb);
> >  		break;
> >  
> > -	case NCI_OP_CORE_CONN_CREATE_RSP:
> > -		nci_core_conn_create_rsp_packet(ndev, skb);
> > -		break;
> > -
> 
> This removal could also be in another patch.
I'll place this removal in a single patch as part of the series of patches (since it belongs to NCI draft18).

> 
> 	Gustavo
> 

Thanks & BR,
Ilan