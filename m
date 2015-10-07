Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from limerock04.mail.cornell.edu ([128.84.13.244]:48773 "EHLO
	limerock04.mail.cornell.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbbJGCkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 22:40:40 -0400
Date: Tue, 6 Oct 2015 22:40:29 -0400
From: Jacob Kiefer <jtk54@cornell.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	"open list:STAGING - REALTEK RTL8723U WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] staging: rtl8723au: Fix sparse errors in
 rtl8723a_cmd.c
Message-ID: <20151007024028.GA2478@jtk54-Q550LF> (sfid-20151007_044058_113625_C60D40B0)
References: <1444105958-32087-1-git-send-email-jtk54@cornell.edu>
 <20151006231134.GV22011@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151006231134.GV22011@ZenIV.linux.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 07, 2015 at 12:11:34AM +0100, Al Viro wrote:
> On Tue, Oct 06, 2015 at 12:32:28AM -0400, Jacob Kiefer wrote:
> 
> >  int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
> >  {
> > -	*((u32 *)param) = cpu_to_le32(*((u32 *)param));
> > +	__le32 leparam;
> > 
> > -	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, param);
> > +	leparam = cpu_to_le32(*((u32 *)param));
> > +
> > +	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (u8 *)&leparam);
> 
> Why not fill the thing we are passing already with little-endian?  There's
> only one caller, after all...
> 

This is a good point. Adding to that, I looked at the one caller: they
take a u32, dereference it and convert it to a u8 pointer and then pass
it into rtl8723a_set_rssi_cmd -- it seems that the u8 *param passed should just
be a __le32 or little-endian u32, and then get deferenced and cast for
FillH2CCmd.

rtl8723a_set_rssi_cmd caller code for reference:
> for (i = 0; i < sta_cnt; i++) {
>     if (PWDB_rssi[i] != (0))
>     rtl8723a_set_rssi_cmd(Adapter, (u8 *)&PWDB_rssi[i]);
> }


> >  int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, u32 mask, u8 arg)
> >  {
> >  	u8 buf[5];
> > +	__le32 lemask;
> > 
> >  	memset(buf, 0, 5);
> > -	mask = cpu_to_le32(mask);
> > -	memcpy(buf, &mask, 4);
> > +	lemask = cpu_to_le32(mask);
> > +	memcpy(buf, &lemask, 4);
> >  	buf[4]  = arg;
> > 
> >  	FillH2CCmd(padapter, MACID_CONFIG_EID, 5, buf);
> 
> Ugh...
> 	struct macid_config_eid {__le32 mask; u8 arg;} buf = {
> 		.mask = cpu_to_le32(mask), .arg = arg
> 	};
> 
> 	FillH2CCmd(padapter, MACID_CONFIG_EID, 5, &buf);
> 
> Why bother with memcpy/memset/whatnot when all you are trying to do is to
> initialize a temporary structure?  And no, it's not going to have any gaps...

This is also a good point -- we can definitely avoid the memcpy/memsets
this way. Additionally, there are only two callers to rtl8723a_set_raid_cmd;
there's no reason the u32 mask can't be passed in as little-endian
__le32 or u32.

One question -- which is preferable: a u32 that we know is
little-endian, or an explicit __le32? __le32 would not cause sparse
errors, so I'm inclined to go that route, is there something wrong with
this?

Going forward, I'm going to split this up into two patches, one for
each function. In each I'll change the interface to take a __le32
instead of what is going on here and make the caller do the le32
conversion. I'll also update the caller references and the .h file
for each. I'll submit them as a patch set later this week.

Let me know your thoughts on this.

Jake
