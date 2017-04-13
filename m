Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34389 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755238AbdDMRuO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 13:50:14 -0400
Received: by mail-pf0-f179.google.com with SMTP id c198so31633836pfc.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 10:50:03 -0700 (PDT)
Date: Thu, 13 Apr 2017 10:49:55 -0700
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxm@marvell.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: Re: [PATCH v3 4/4] mwifiex: pcie: extract wifi part from combo
 firmware during function level reset
Message-ID: <20170413174954.GA66124@google.com> (sfid-20170413_195048_253341_DA9C3547)
References: <1491815374-6555-1-git-send-email-huxinming820@gmail.com>
 <1491815374-6555-4-git-send-email-huxinming820@gmail.com>
 <20170411013724.GA135531@google.com>
 <45a8fcd4f0384fa7b622cf3a87b41ea8@SC-EXCH02.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <45a8fcd4f0384fa7b622cf3a87b41ea8@SC-EXCH02.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Apr 13, 2017 at 06:47:59AM +0000, Xinming Hu wrote:
> > -----Original Message-----
> > From: Brian Norris [mailto:briannorris@chromium.org]
> > Sent: 2017年4月11日 9:37
> > To: Xinming Hu
> > Cc: Linux Wireless; Kalle Valo; Dmitry Torokhov; rajatja@google.com;
> > Amitkumar Karwar; Cathy Luo; Xinming Hu; Ganapathi Bhat
> > Subject: [EXT] Re: [PATCH v3 4/4] mwifiex: pcie: extract wifi part from combo
> > firmware during function level reset
> > 
> > External Email
> > 

> > On Mon, Apr 10, 2017 at 09:09:34AM +0000, Xinming Hu wrote:
> > > +	while (1) {
> > > +		if (offset + sizeof(fwdata.header) >= firmware_len) {
> > > +			mwifiex_dbg(adapter, ERROR,
> > > +				    "extract wifi-only firmware failure!");
> > > +			ret = -1;
> > > +			goto done;
> > > +		}
> > > +
> > > +		memcpy(&fwdata.header, firmware + offset,
> > > +		       sizeof(fwdata.header));
> > 
> > Do you actually need to copy this? Can't you just keep a pointer to the location?
> > e.g.
> > 
> > 	const struct mwifiex_fw_data *fwdata;
> > ...
> > 	fwdata = firmware + offset;
> > 
> 
> Ok.
> 
> > > +		dnld_cmd = le32_to_cpu(fwdata.header.dnld_cmd);
> > > +		data_len = le32_to_cpu(fwdata.header.data_length);
> > > +
> > > +		switch (dnld_cmd) {
> > > +		case MWIFIEX_FW_DNLD_CMD_1:
> > > +			if (!cmd7_before) {
> > > +				mwifiex_dbg(adapter, ERROR,
> > > +					    "no cmd7 before cmd1!");
> > > +				ret = -1;
> > > +				goto done;
> > > +			}
> > > +			offset += data_len + sizeof(fwdata.header);
> > 
> > Technically, we need an overflow check to make sure that 'data_len'
> > isn't some bogus value that overflows 'offset'.
> > 
> 
> There is the sanity check for the offset after bypass CMD1/5/7 in the start of while-loop, enhanced in v4 as,
> if (offset >= firmware_len)

That's not an enhancement!! That's a *weaker* condition, and it's wrong.
If 'offset == firmware_len - 1', then we'll still be out of bounds when
we read the next header at 'offset + {1, 2, 3, ...}'.

My point was that adding 'data_len' might actually overflow the u32, not
that the bounds check ('offset + sizeof(...header) >= firmware_len') was
wrong.

For this kind of overflow check, you need to do the check here, not
after you've saved the new offset.

e.g., suppose data_len = 0xfffffff0. Then:

	offset += data_len + sizeof(fwdata.header);
=>
	offset += 0xfffffff0 + 16;
=>
	offset += 0;

and then...we have an infinite loop. Changing the bounds check at the
start of the loop does nothing to help this.

Something like this (put before the addition) is sufficient, I think:

	if (offset + data_len + sizeof(fwdata.header) < data_len)
		... error ...

Or this would actually all be slightly cleaner if you just did this
outside the 'switch':

	// Presuming you already did the check for
	//  offset + sizeof(fwdata.header) >= firmware_len
	offset += sizeof(fwdata.header);

Then inside this 'case', you have:

	if (offset + data_len < data_len)
		... error out ...
	offset += data_len;

> > > +			break;
> > > +		case MWIFIEX_FW_DNLD_CMD_5:
> > > +			offset += data_len + sizeof(fwdata.header);
> > 
> > Same here.
> > 
> > > +			break;
> > > +		case MWIFIEX_FW_DNLD_CMD_6:
> > 
> > Can we have a comment, either here or above this function, to describe what
> > this sequence is? Or particularly, what is this terminating condition? "CMD_6"
> > doesn't really tell me that this is the start of the Wifi blob.
> > 
> > > +			offset += data_len + sizeof(fwdata.header);
> > 
> 
> The sequence have been added to function comments in v4.
> 
> > You don't check for overflow here. Check this before returning this (either here,
> > or in the 'done' label).
> > 
> 
> Yes, add sanity check for the offset in end of CMD6.
> 
> > > +			ret = offset;
> > > +			goto done;
> > > +		case MWIFIEX_FW_DNLD_CMD_7:
> > > +			if (!cmd7_before)
> > 
> > ^^ This 'if' isn't really needed.
> 
> Done.
> 
> > 
> > > +				cmd7_before = true;
> > > +			offset += sizeof(fwdata.header);
> > > +			break;
> > > +		default:
> > > +			mwifiex_dbg(adapter, ERROR, "unknown dnld_cmd %d\n",
> > > +				    dnld_cmd);
> > > +			ret = -1;
> > > +			goto done;
> > > +		}
> > > +	}
> > > +
> > > +done:
> > > +	return ret;
> > > +}

[...]

Brian
