Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:54148 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863Ab1KAQ0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 12:26:16 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: Gustavo Padovan <padovan@profusion.mobi>
CC: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 1 Nov 2011 17:25:53 +0100
Subject: RE: [PATCH v2] NFC: update to NCI spec 1.0 draft 18
Message-ID: <AC090B9732AB2B4DB7FF476E907FE660013BAECA09@dnce02.ent.ti.com> (sfid-20111101_172622_563993_ED9F3ACA)
References: <1319551485-17963-1-git-send-email-ilane@ti.com>
 <20111031155151.GA9177@joana>
 <AC090B9732AB2B4DB7FF476E907FE660013BAEC736@dnce02.ent.ti.com>
 <20111101151209.GA2580@joana>
In-Reply-To: <20111101151209.GA2580@joana>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
Hi Gustavo,

> > > > -static void nci_rf_activate_ntf_packet(struct nci_dev *ndev,
> > > > -					struct sk_buff *skb)
> > > > +static void nci_rf_intf_activated_ntf_packet(struct 
> nci_dev *ndev,
> > > > +						struct 
> sk_buff *skb)
> > > >  {
> > > > -	struct nci_rf_activate_ntf ntf;
> > > > +	struct nci_rf_intf_activated_ntf ntf;
> > > >  	__u8 *data = skb->data;
> > > > -	int rc = -1;
> > > > +	int err = 0;
> > > >  
> > > >  	clear_bit(NCI_DISCOVERY, &ndev->flags);
> > > >  	set_bit(NCI_POLL_ACTIVE, &ndev->flags);
> > > >  
> > > > -	ntf.target_handle = *data++;
> > > > +	ntf.rf_discovery_id = *data++;
> > > > +	ntf.rf_interface_type = *data++;
> > > >  	ntf.rf_protocol = *data++;
> > > > -	ntf.rf_tech_and_mode = *data++;
> > > > +	ntf.activation_rf_tech_and_mode = *data++;
> > > >  	ntf.rf_tech_specific_params_len = *data++;
> > > >  
> > > > -	nfc_dbg("target_handle %d, rf_protocol 0x%x, 
> > > rf_tech_and_mode 0x%x, rf_tech_specific_params_len %d",
> > > > -		ntf.target_handle,
> > > > -		ntf.rf_protocol,
> > > > -		ntf.rf_tech_and_mode,
> > > > +	nfc_dbg("rf_discovery_id %d", ntf.rf_discovery_id);
> > > > +	nfc_dbg("rf_interface_type 0x%x", 
> ntf.rf_interface_type);
> > > > +	nfc_dbg("rf_protocol 0x%x", ntf.rf_protocol);
> > > > +	nfc_dbg("activation_rf_tech_and_mode 0x%x",
> > > > +		ntf.activation_rf_tech_and_mode);
> > > > +	nfc_dbg("rf_tech_specific_params_len %d",
> > > >  		ntf.rf_tech_specific_params_len);
> > > >  
> > > > -	switch (ntf.rf_tech_and_mode) {
> > > > -	case NCI_NFC_A_PASSIVE_POLL_MODE:
> > > > -		rc = 
> nci_rf_activate_nfca_passive_poll(ndev, &ntf,
> > > > -			data);
> > > > -		break;
> > > > +	if (ntf.rf_tech_specific_params_len > 0) {
> > > > +		switch (ntf.activation_rf_tech_and_mode) {
> > > > +		case NCI_NFC_A_PASSIVE_POLL_MODE:
> > > > +			data = 
> > > nci_extract_rf_params_nfca_passive_poll(ndev,
> > > > +				&ntf, data);
> > > > +			break;
> > > > +
> > > > +		default:
> > > > +			nfc_err("unsupported 
> > > activation_rf_tech_and_mode 0x%x",
> > > > +				
> ntf.activation_rf_tech_and_mode);
> > > > +			return;
> > > > +		}
> > > > +	}
> > > >  
> > > > -	default:
> > > > -		nfc_err("unsupported rf_tech_and_mode 0x%x",
> > > > -			ntf.rf_tech_and_mode);
> > > > -		return;
> > > > +	ntf.data_exchange_rf_tech_and_mode = *data++;
> > > > +	ntf.data_exchange_tx_bit_rate = *data++;
> > > > +	ntf.data_exchange_rx_bit_rate = *data++;
> > > > +	ntf.activation_params_len = *data++;
> > > > +
> > > > +	nfc_dbg("data_exchange_rf_tech_and_mode 0x%x",
> > > > +		ntf.data_exchange_rf_tech_and_mode);
> > > > +	nfc_dbg("data_exchange_tx_bit_rate 0x%x",
> > > > +		ntf.data_exchange_tx_bit_rate);
> > > > +	nfc_dbg("data_exchange_rx_bit_rate 0x%x",
> > > > +		ntf.data_exchange_rx_bit_rate);
> > > > +	nfc_dbg("activation_params_len %d",
> > > > +		ntf.activation_params_len);
> > > > +
> > > > +	if (ntf.activation_params_len > 0) {
> > > 
> > > Seems to me that ntf.activation_params_len > 0 can be a check 
> > > in the beginning
> > > of this function.
> > Actually, each param is read in order (as you can see the 
> pointer data is advanced on each param read).
> > The order is important, since it's clearer and some 
> parameters are depend on the previous ones (e.g. we must read 
> activation_rf_tech_and_mode before we read the activation params).
> > So, activation_params_len is read when we arrive to its 
> location in the data stream.
> > In any case, I don't see the benefit in checking the 
> condition in the beginning of the function (since I still 
> need to read the other params).
> 
> Sure, I didn't realize this in my quick look to this code. 
> But this remind me
> another thing. Why are you reading your data like this, each 
> member at a time?
> Can't you do something like this:
> 
>  	struct ntf *ntf = skb->data;
> 
> Then if you need to copy them to another places, or do memcpy 
> or pick the ones
> you want by assign them to other variables.
Wherever I can read them into a pointer like you suggest, I do it (as you can see with all other packets).

In this case, the packet is complicated, since it includes lots of different sub-structs depending on the previous fields.
Also, some fields have variable length (so I need to keep track of the current position all the time).
In addition, some fields are bigger than 1 byte and need to be converted from little-endian to local CPU.

The reason for the complication lies in the nature of NFC, where we're expected to support multiple technologies and protocols (represented in 1 single packet).
For example, we can receive activation from tech A tags or B, F etc...each of them have different representation.

For simplicity of the code and the parsing, we represent all the information of a activation ntf in a single struct.
Of course, this struct does not represent the true protocol format (as explained above).

> 
> 	Gustavo
> 

Thanks & BR,
Ilan
