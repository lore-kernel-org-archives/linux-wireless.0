Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5DD3D525F;
	Wed, 20 May 2026 09:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779270122; cv=none; b=Fm8Sujq5yPBBO70wx0LG/9ZLRyziQCy8rUwwsKknphsALtnV4iBC2Ach6/93jhlJGj2HEvVClqlW5RH8BkxL+hScG4O/KK1xvKGtOZpmR/KlbQYc+8CxUt/VMO0R/EKPqZai4W65N6aXL/hDU9SjyZ+PAjfna5Uk1NbjLeLGuV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779270122; c=relaxed/simple;
	bh=PNkrzmGBLmsK4+moTXk9hO6Q9VekSgGwVt/iwFGPMTg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iMl5GVYfVLCxv9STyzwNkXD7v7RAaMCllZPM+E8yDdzq0fWqMkWGXOsGvYZdggg1JdWd18NlxktYJRgE6FD84ZlxkcaWmxNtwO6c0tgJv1cgP/mycLb5dbAiRczEzwy0kaQKX2CsjTmArsv22O1vwGkMvD8UnkUEJ20yoMgriwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=GXbYkWcY; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="GXbYkWcY"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 64K9fmdZ7012899, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1779270108; bh=Z8IrZGgYitLHMLLS1HXSi7SkcWX36UenWXqwZz6hcWE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=GXbYkWcYeXJ7ybLfg4tn/4YjOLW9X3JKmIpJgB1jtf1V0Z91kD81k2NnMqwcRf7tE
	 O9nAKnCk0qDwP73gokdeAcBLRKEVqwtF/qNp5XHpZvD+3t467o6oQHwraiNmdmPeeb
	 olPCOycZKi8hfwNJwgMd/pC3RdiBo8dXq0zGhQczhTmfKpRadlX2+ue11hL/821wiO
	 wjyoOArVF+arOw9Hsc7wlWUlUqD3IYttpptaIWoor1uvxYSXGFNqCFH/r1G8QF/6EE
	 CnV9fP9Qv6ZBu5w8GktuPg0IlbCDahIxzKWTQWqpYId82th6pbH5ZRpMrxHkSYtBPU
	 VCg0NTeB/5yLQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.28/5.94) with ESMTPS id 64K9fmdZ7012899
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 17:41:48 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 May 2026 17:41:48 +0800
Received: from RTKEXHMBS04.realtek.com.tw ([::1]) by
 RTKEXHMBS04.realtek.com.tw ([fe80::552f:8b32:656c:c395%6]) with mapi id
 15.02.2562.017; Wed, 20 May 2026 17:41:48 +0800
From: Johnson Tsai <wenjie.tsai@realtek.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Johannes Berg
	<johannes@sipsolutions.net>
CC: Ping-Ke Shih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>,
        "driver-core@lists.linux.dev"
	<driver-core@lists.linux.dev>,
        "sabae@valvesoftware.com"
	<sabae@valvesoftware.com>,
        Charles Lohr <charlesl@valvesoftware.com>
Subject: RE: [RFC rtw-next 1/2] wifi: rtw89: usb: add hw_info sysfs attribute
Thread-Topic: [RFC rtw-next 1/2] wifi: rtw89: usb: add hw_info sysfs attribute
Thread-Index: AQHc52CHOsKUzQ+SEUSORaNAsdGbNbYUb+IAgABMgwCAAAMoAIAB5JEQ
Date: Wed, 20 May 2026 09:41:46 +0000
Message-ID: <b8640de28c5e4a94a3c2bbc3a101c1fa@realtek.com>
References: <20260519072415.25746-1-pkshih@realtek.com>
 <efb61959e14e4f57b78fbd49a563398e@realtek.com>
 <83ddb427597663b947c49afd835014f2bc1033f2.camel@sipsolutions.net>
 <2026051957-refract-barge-b21e@gregkh>
In-Reply-To: <2026051957-refract-barge-b21e@gregkh>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0



On Tuesday, May 19, 2026 20:23, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, May 19, 2026 at 02:11:32PM +0200, Johannes Berg wrote:
> > Hi,
> >
> > > > Example usage from user-space:
> > > >   $ cat /sys/bus/usb/devices/2-3.1.2:1.0/hw_info
> > > >   SN: 36 42 00 01 23
> > > >   UUID: aa ec 2b 7c 0a 55 47 27 8d e0 b3 0f eb cc bb aa
> >
> > Sysfs has a "one value per file" rule (soft rule according to the
> > docs, but harder in practice, I believe), so seems if anything that
> > should be two files. Maybe a UUID should also be formatted as such
> > with %pU or similar.
>=20
> That should be 2 separate sysfs files please.
>=20
> And yes, use %pU.

The v2 patch will use separate `sn` and `uuid` attributes, with `uuid`
formatted via `%pU`. We also removed the spaces in `sn` to provide a clean
string.

Example usage from user-space:
  $ cat /sys/bus/usb/devices/2-3.1.2:1.0/sn
  3642000123
  $ cat /sys/bus/usb/devices/2-3.1.2:1.0/uuid
  aaec2b7c-0a55-4727-8de0-b30febccbbaa

>=20
> And be careful about exposing serial numbers to userspace, some systems
> don't like normal users to read them so be sure to get the permissions co=
rrect.
> We had to add some USB code for ALLOW_SERIAL_NUMBER to make it so that
> systems can handle this if they want to.
>=20
> And shouldn't this just be the USB serial number to start with?  Why is t=
here a
> different string here?  We already have a sysfs file for this value.

Regarding the serial number and permission design, these are requirements=20
from Valve, so we have CC'd them here to provide the background.

Hi Elliot and Charles, could you please help explain the requirements and u=
se case here?



