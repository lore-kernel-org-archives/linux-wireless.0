Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:49483 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbYDISHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 14:07:15 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] Add Realtek 8187B support
Date: Wed, 9 Apr 2008 15:07:10 -0300
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200804081931.07638.herton@mandriva.com.br> <1207722700.8539.80.camel@rd>
In-Reply-To: <1207722700.8539.80.camel@rd>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804091507.10816.herton@mandriva.com.br> (sfid-20080409_190720_892657_DF1F138E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Wednesday 09 April 2008 03:31:40 Pavel Roskin escreveu:
> On Tue, 2008-04-08 at 19:31 -0300, Herton Ronaldo Krzesinski wrote:
> 
> P.S. More stuff as I'm going through the patch.  Sorry, I had to post
> the first reply quickly to disavow my Signed-off-by.
> 
> > Also I fixed a bug of a missing "priv->vif = vif" in rtl8187_config_interface
> > that makes kernel oops in transmit code in ieee80211_generic_frame_duration
> > function.
> 
> This should be a separate patch.  In the kernel, it's very important to
> be able to pinpoint which change broke things.  And git is well suited
> for working with multiple patches (my personal preference is StGIT,
> which is not just suited for that - it's the main thing StGIT does).

I'll submit a separate patch.

> 
> > diff --git a/drivers/net/wireless/rtl8180_rtl8225.c b/drivers/net/wireless/rtl8180_rtl8225.c
> > index cd22781..b4c6ae0 100644
> > --- a/drivers/net/wireless/rtl8180_rtl8225.c
> > +++ b/drivers/net/wireless/rtl8180_rtl8225.c
> > @@ -718,10 +718,7 @@ static void rtl8225_rf_set_channel(struct ieee80211_hw *dev,
> >  	struct rtl8180_priv *priv = dev->priv;
> >  	int chan = ieee80211_frequency_to_channel(conf->channel->center_freq);
> >  
> > -	if (priv->rf->init == rtl8225_rf_init)
> > -		rtl8225_rf_set_tx_power(dev, chan);
> > -	else
> > -		rtl8225z2_rf_set_tx_power(dev, chan);
> > +	priv->rf->set_txpwr(dev, chan);
> 
> It seems to me it's unrelated to rtl8187b support.  You are doing some
> unrelated refactoring here, which could be done in a separate patch.

The problem is that if I don't do this, in rtl8225_rf_set_channel in
rtl8187_rtl8225.c I would have to add more checks for what function to call,
so I introduced this that seemed more cleaner. I'll provide too a separate
patch for that then if people find to be better.

> 
> > -	.set_chan	= rtl8225_rf_set_channel
> > +	.set_chan	= rtl8225_rf_set_channel,
> > +	.set_txpwr	= rtl8225_rf_set_tx_power
> 
> Same thing here.  If you need extra infrastructure, add it in one patch
> and leave hardware support for another.
> 
> > +struct rtl8187b_rx_hdr {
> > +	__le32 flags;
> > +	__le64 mac_time;
> > +	u8 noise;
> > +	u8 signal;
> > +	u8 agc;
> > +	u8 reserved;
> > +	__le32 unused;
> > +} __attribute__((packed));
> 
> I know, you are copying parts from the rtl8187 header.  But looking at
> the vendor driver, "reserved" and "unused" are better described.  Nobody
> would guess it by looking at this header.  It would be great if you at
> least give a hint that the vendor driver describes the structure of
> those fields.  That should be a separate patch, of course.

I used the same style used already in original rtl8187: if there is reserved
bitfields just use reserved, otherwise unused. The vendor drivers uses this for
tx/rx:

struct tx_desc {

#ifdef _LINUX_BYTEORDER_LITTLE_ENDIAN_H

//dword 0
unsigned int    tpktsize:12;
unsigned int    rsvd0:3;
unsigned int    no_encrypt:1;
unsigned int    splcp:1;
unsigned int    morefrag:1;
unsigned int    ctsen:1;
unsigned int    rtsrate:4;
unsigned int    rtsen:1;
unsigned int    txrate:4;
unsigned int    last:1;
unsigned int    first:1;
unsigned int    dmaok:1;
unsigned int    own:1;

//dword 1
unsigned short  rtsdur;
unsigned short  length:15;
unsigned short  l_ext:1;

//dword 2
unsigned int    bufaddr;

//dword 3
unsigned short  rxlen:12;
unsigned short  rsvd1:3;
unsigned short  miccal:1;
unsigned short  dur;

//dword 4
unsigned int    nextdescaddr;

//dword 5
unsigned char   rtsagc;
unsigned char   retrylimit;
unsigned short  rtdb:1;
unsigned short  noacm:1;
unsigned short  pifs:1;
unsigned short  rsvd2:4;
unsigned short  rtsratefallback:4;
unsigned short  ratefallback:5;

//dword 6
unsigned short  delaybound;
unsigned short  rsvd3:4;
unsigned short  agc:8;
unsigned short  antenna:1;
unsigned short  spc:2;
unsigned short  rsvd4:1;

//dword 7
unsigned char   len_adjust:2;
unsigned char   rsvd5:1;
unsigned char   tpcdesen:1;
unsigned char   tpcpolarity:2;
unsigned char   tpcen:1;
unsigned char   pten:1;

unsigned char   bckey:6;
unsigned char   enbckey:1;
unsigned char   enpmpd:1;
unsigned short  fragqsz;

#else

#error "please modify tx_desc to your own\n"

#endif

} __attribute__((packed));

struct rx_desc_rtl8187b {

#ifdef _LINUX_BYTEORDER_LITTLE_ENDIAN_H

//dword 0
unsigned int    rxlen:12;
unsigned int    icv:1;
unsigned int    crc32:1;
unsigned int    pwrmgt:1;
unsigned int    res:1;
unsigned int    bar:1;
unsigned int    pam:1;
unsigned int    mar:1;
unsigned int    qos:1;
unsigned int    rxrate:4;
unsigned int    trsw:1;
unsigned int    splcp:1;
unsigned int    fovf:1;
unsigned int    dmafail:1;
unsigned int    last:1;
unsigned int    first:1;
unsigned int    eor:1;
unsigned int    own:1;

//dword 1
unsigned int    tsftl;

//dword 2
unsigned int    tsfth;

//dword 3
unsigned char   sq;
unsigned char   rssi:7;
unsigned char   antenna:1;

unsigned char   agc;
unsigned char   decrypted:1;
unsigned char   wakeup:1;
unsigned char   shift:1;
unsigned char   rsvd0:5;

//dword 4
unsigned int    num_mcsi:4;
unsigned int    snr_long2end:6;
unsigned int    cfo_bias:6;

unsigned int    pwdb_g12:8;
unsigned int    fot:8;

#else

#error "please modify tx_desc to your own\n"

#endif

}__attribute__((packed));

struct rx_desc_rtl8187 {

#ifdef _LINUX_BYTEORDER_LITTLE_ENDIAN_H

//dword 0
unsigned int    rxlen:12;
unsigned int    icv:1;
unsigned int    crc32:1;
unsigned int    pwrmgt:1;
unsigned int    res:1;
unsigned int    bar:1;
unsigned int    pam:1;
unsigned int    mar:1;
unsigned int    qos:1;
unsigned int    rxrate:4;
unsigned int    trsw:1;
unsigned int    splcp:1;
unsigned int    fovf:1;
unsigned int    dmafail:1;
unsigned int    last:1;
unsigned int    first:1;
unsigned int    eor:1;
unsigned int    own:1;

//dword 1
unsigned char   sq;
unsigned char   rssi:7;
unsigned char   antenna:1;

unsigned char   agc;
unsigned char   decrypted:1;
unsigned char   wakeup:1;
unsigned char   shift:1;
unsigned char   rsvd0:5;

//dword 2
unsigned int tsftl;

//dword 3
unsigned int tsfth;

#else

#error "please modify tx_desc to your own\n"

#endif

}__attribute__((packed));

I can just then define all fields/bits like the original driver, but anyway
would not be useful, as we don't know what all these bits do (no documentation)
and even Realtek doesn't uses them in the driver.

> 
> > +struct rtl8187b_tx_hdr {
> > +	__le32 flags;
> > +	__le16 rts_duration;
> > +	__le16 len;
> > +	__le32 unused_1;
> > +	__le16 unused_2;
> > +	__le16 tx_duration;
> > +	__le32 unused_3;
> > +	__le32 retry;
> > +	__le32 unused_4[2];
> > +} __attribute__((packed));
> 
> Those are indeed "unused in" the vendor driver.
> 
> > +#define DEVICE_RTL8187	0
> > +#define DEVICE_RTL8187B	1
> 
> I prefer enums here, but I don't feel strongly about it.
> 
> >  struct rtl8187_priv {
> >  	/* common between rtl818x drivers */
> >  	struct rtl818x_csr *map;
> > @@ -76,70 +103,100 @@ struct rtl8187_priv {
> >  	u32 rx_conf;
> >  	u16 txpwr_base;
> >  	u8 asic_rev;
> > +	u8 is_rtl8187b;
> > +	enum {
> > +		RTL8187BvB,
> > +		RTL8187BvD,
> > +		RTL8187BvE
> > +	} hw_rev;
> 
> Or maybe we could have one enum here, and use (hw_rev > DEVICE_RTL8187)
> instead of is_rtl8187b.  Maybe there will be future revisions that
> change something else.  The standard approaches are flags that are ORed
> or enums that are compared.  is_something doesn't scale well.

Ok, I'll merge and compare using '>'

>  
> > -static inline u8 rtl818x_ioread8(struct rtl8187_priv *priv, u8 *addr)
> > +static inline u8 rtl818x_ioread8_idx(struct rtl8187_priv *priv,
> > +				     u8 *addr, u8 idx)
> >  {
> >  	u8 val;
> >  
> >  	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
> >  			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
> > -			(unsigned long)addr, 0, &val, sizeof(val), HZ / 2);
> > +			(unsigned long)addr, idx & 0x03, &val,
> > +			sizeof(val), HZ / 2);
> 
> As I said, "addr" should not be a pointer.  In fact, the fifth argument
> is __u16.  There is no way a valid pointer can even be passed to
> usb_control_msg() without truncating it.  Make it __u16 and remove all
> casts unless they are needed and you know why.

I don't understand how it could be truncated, but indeed this casts are not
needed at all. I'll make another patch, as like I said at the other mail I just
followed what was already on rtl8187.

> 
> > -static inline u16 rtl818x_ioread16(struct rtl8187_priv *priv, __le16 *addr)
> > +#define rtl818x_ioread8(priv, addr) rtl818x_ioread8_idx(priv, addr, 0)
> 
> Inline functions are preferred for that.

Will do as inline function.

> 
> > +static inline u16 rtl818x_ioread16_idx(struct rtl8187_priv *priv,
> > +				       __le16 *addr, u8 idx)
> >  {
> >  	__le16 val;
> >  
> >  	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
> >  			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
> > -			(unsigned long)addr, 0, &val, sizeof(val), HZ / 2);
> > +			(unsigned long)addr, idx & 0x03, &val,
> > +			sizeof(val), HZ / 2);
> 
> More of the same stuff.
>  
> >  static struct usb_device_id rtl8187_table[] __devinitdata = {
> > -	/* Realtek */
> > -	{USB_DEVICE(0x0bda, 0x8187)},
> > +	/* Realtek 8187 */
> > +	{USB_DEVICE(0x0bda, 0x8187), .driver_info = DEVICE_RTL8187},
> 
> You are mixing to things in the comment.  DEVICE_RTL8187 already
> indicates that it's 8187.  Better keep Realtek devices together, and
> leave the details to the code.

I'll group them together on the same entry.

> 
> > -	hdr = (struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));
> > -	hdr->flags = cpu_to_le32(flags);
> > -	hdr->len = 0;
> > -	hdr->rts_duration = rts_dur;
> > -	hdr->retry = cpu_to_le32(control->retry_limit << 8);
> > +	if (!priv->is_rtl8187b) {
> 
> I would explore the possibility of splitting the hardware specific parts
> of rtl8187_tx() into two separate functions.

I'll split them.

> 
> > @@ -240,11 +264,25 @@ static void rtl8187_rx_cb(struct urb *urb)
> 
> And the same on the rx side.  gcc is good at inlining static functions
> that are used once.
> 
> > +		rx_status.mactime = le64_to_cpu(hdr_b->mac_time);
> 
> Careful here!  mac_time is not size-aligned in rtl8187b_rx_hdr.  I would
> ask our alignment gurus it it's OK.

I don't know much about alignment or possible problems in this, seems to be ok,
who can verify this?

> 
> > -static int rtl8187_init_hw(struct ieee80211_hw *dev)
> > +static int rtl8187_cmd_reset(struct ieee80211_hw *dev)
> >  {
> >  	struct rtl8187_priv *priv = dev->priv;
> >  	u8 reg;
> >  	int i;
> 
> It seems to me that there is too much in common between those functions.
> Please consider refactoring.  I would also suggest that you submit it
> separately.

? In fact what was in common was reset code, that I already splitted. About
the rest of hardware initialization they are very different, some commands
are equal but may be the hardware requires a specific sequence, we can't be
sure as there is no documentation.

> 
> Skipping lots of stuff for a later review, as it's getting late, and the
> end it far away.  I hope you got the idea.
> 
> >  	u8	reserved_19[3];
> > +	__le16	INT_MIG;
> > +#define RTL818X_R8187B_B	0
> > +#define RTL818X_R8187B_D	1
> > +#define RTL818X_R8187B_E	2
> 
> You are inconsistent here.  You were using an enum in another structure
> essentially for the same thing.
> 

Nope, these are specific values returned by hardware (see rtl8187_probe where
these are used).

--
[]'s
Herton
