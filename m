Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:49296 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbZCPMKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 08:10:39 -0400
Received: by yx-out-2324.google.com with SMTP id 8so996665yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 05:10:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c4d76b3b0903122031o7baea17ay5704df428ea2fced@mail.gmail.com>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <1236211493.6612.90.camel@rc-desk> <1236297052.6153.4.camel@rainbow>
	 <1236299085.6612.229.camel@rc-desk>
	 <1236312734.19328.37.camel@rainbow> <1236317982.12430.9.camel@rc-desk>
	 <1236649234.6685.9.camel@rainbow> <1236661466.15923.53.camel@rc-desk>
	 <1236742805.6267.9.camel@rainbow>
	 <c4d76b3b0903122031o7baea17ay5704df428ea2fced@mail.gmail.com>
Date: Mon, 16 Mar 2009 08:10:35 -0400
Message-ID: <c4d76b3b0903160510i5afc6cd6t856b63383a275fca@mail.gmail.com> (sfid-20090316_131045_414630_FEA40A3D)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 12, 2009 at 11:31 PM, Jason Andryuk <jandryuk@gmail.com> wr=
ote:
> On Tue, Mar 10, 2009 at 11:40 PM, Jason Andryuk <jandryuk@gmail.com> =
wrote:
>>> You log below has a new error (similar to what you note in your nex=
t
>>> email). "Unsupported interface type 515". This is very strange and
>>> really looks like some corruption as this value is initialized with=
 a
>>> macro during probe. Could you enable mac and info debugging also (a=
dd
>>> 0x3 to your current debug flags)? This code has also changed a bit =
since
>>> commit bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d.

> Looking at ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f, I found the call
> to iwl_reset_qos corrupts priv->iw_mode. =A0It is 2 before the call a=
nd
> 515 after.

Turns out that iwlcore.ko was stale with respect to iwl3945.ko.  The
older iwl_reset_qos in iwlcore.ko used an incorrect offset to access
priv->qos_data.

Unfortunately this did not solve the Microcode SW error, and I spent a
lot of time chasing the wrong issue.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
