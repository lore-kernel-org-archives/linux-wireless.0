Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0064.outbound.protection.outlook.com ([104.47.36.64]:60400
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752046AbcK2CGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 21:06:34 -0500
From: "Schaefer, Brandon" <brandon.schaefer@flukenetworks.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: CRDA/wireless-regdb to limit communication to certified countries
Date: Tue, 29 Nov 2016 00:32:25 +0000
Message-ID: <BN6PR12MB1442F053ADBC73A276F2C9F3908D0@BN6PR12MB1442.namprd12.prod.outlook.com> (sfid-20161129_030638_914014_EFA3C08E)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm in need of a way to meet various levels of certification based on the c=
ountry the device is operating in. For example, let's say the device will b=
e certified for 2.4 GHz and 5GHz in the US but in Japan it will be limited =
to 2.4GHz. In order to do so, I've modified wireless-regdb used by CRDA and=
 it seems to work okay by country once associated with an AP, but I still h=
ave a few questions (mostly related to clarification of information from ht=
tps://wireless.wiki.kernel.org/en/developers/regulatory/processing_rules).

1)  The NO-IR flag prevents a device from initiating radiation on a channel=
, but supposedly it can be lifted while world roaming if an AP is broadcast=
ing on that channel. Suppose my device is world roaming (country code 00) a=
nd all channels in country 00 are set to NO-IR.
What happens if my device notices an AP beaconing with country IE of Japan =
on a channel that was originally NO-IR?
A country IE is said to be ignored until we try to associate with it, will =
the device now allow initiation of radiation on the channels which the AP w=
as beaconing on?

2) I noticed in country 00 that the power of 60GHz channels were set to 0. =
Is this a better way of truly disabling transmission on certain frequencies=
 until a Country Information Element is received from an AP? The main goal =
is to follow our certification by country correctly, and allow no transmiss=
ions that would violate certifications.

Thanks for any and all input!

Brandon
________________________________
________________________________


Please be advised that this email may contain confidential information. If =
you are not the intended recipient, please notify us by email by replying t=
o the sender and delete this message. The sender disclaims that the content=
 of this email constitutes an offer to enter into, or the acceptance of, an=
y agreement; provided that the foregoing does not invalidate the binding ef=
fect of any digital or other electronic reproduction of a manual signature =
that is included in any attachment.
