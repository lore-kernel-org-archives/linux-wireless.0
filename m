Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:56601 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab1JHT3p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 15:29:45 -0400
Date: Sat, 8 Oct 2011 22:29:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mb@bu3sch.de
Cc: linux-wireless@vger.kernel.org
Subject: problem in b43_nrssi_hw_update()?
Message-ID: <20111008192913.GA1585@elgon.mountain> (sfid-20111008_212954_969612_3D45D8FD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My latest testing version of Smatch complains about the wrapping in
b43_nrssi_hw_update() when val is 0xffff. The function is defined
like this:

/* http://bcm-specs.sipsolutions.net/NRSSILookupTable */
static void b43_nrssi_hw_update(struct b43_wldev *dev, u16 val)
{
        u16 i;
        s16 tmp;

	for (i = 0; i < 64; i++) {
                tmp = b43_nrssi_hw_read(dev, i);
                tmp -= val;
                tmp = clamp_val(tmp, -32, 31);
                b43_nrssi_hw_write(dev, i, tmp);
        }
}

It's only called from one place like this:

                /* The specs state to update the NRSSI LT with
                 * the value 0x7FFFFFFF here. I think that is some weird
                 * compiler optimization in the original driver.
                 * Essentially, what we do here is resetting all NRSSI LT
                 * entries to -32 (see the clamp_val() in nrssi_hw_update())
                 */
                b43_nrssi_hw_update(dev, 0xFFFF);       //FIXME?

Since tmp in b43_nrssi_hw_update() is s16 and val is always
(u16)0xFFFF, that means that:
	tmp -= val;
is always the same just tmp += 1;

This code has a fixme, and it seems like an overly complicated way
of adding 1 to a variable, plus it doesn't seem to match the
documentation very well.  :P

I know you've looked at this before and that's why it has the FIXME
comment...  I'm not sure what to do...

regards,
dan carpenter
