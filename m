Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4763 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab3JaRnV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 13:43:21 -0400
Message-ID: <52729681.5020004@broadcom.com> (sfid-20131031_184329_244161_F79517CC)
Date: Thu, 31 Oct 2013 18:42:25 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j@w1.fi" <j@w1.fi>
Subject: Re: [PATCH] cfg80211: Introduce critical protocol indication
 for p2p connection.
References: <1383230452-12608-1-git-send-email-usdutt@qti.qualcomm.com>
 (sfid-20131031_154108_037102_6F3E1A6D)
 <1383230593.14302.1.camel@jlt4.sipsolutions.net>
 <26F3B0343EE4744AA14EEEF9E1E534511F7A65CC@aphydexd01a>
 <1383233115.14302.2.camel@jlt4.sipsolutions.net>
 <26F3B0343EE4744AA14EEEF9E1E534511F7A6606@aphydexd01a>
In-Reply-To: <26F3B0343EE4744AA14EEEF9E1E534511F7A6606@aphydexd01a>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/13 16:54, Undekari, Sunil Dutt wrote:
>> Just do it in the supplicant - that has full control over what's going on with a given device.
>> Trying to have the kernel manage multiple things that may or may not be exclusive and are all done in userspace is going to be a futile exercise.
> Please note that the scans that are mentioned by me in this context are not triggered by the supplicant, rather the host driver would initiate them.

So how would the scenario look like. The host driver will get involved 
in setting up the P2P connection so that knowledge is already available 
to defer the scans or am I missing something.

Regards,
Arend

> The driver / firmware would do such scans for a better roam performance.
> I would say, some handshake between the supplicant and the driver would be needed for a better understanding on the operations.
> Please have your say.
> Regards,
> Sunil
>
> -----Original Message-----
> From: Johannes Berg [mailto:johannes@sipsolutions.net]
> Sent: Thursday, October 31, 2013 8:55 PM
> To: Undekari, Sunil Dutt
> Cc: linux-wireless@vger.kernel.org; j@w1.fi
> Subject: Re: [PATCH] cfg80211: Introduce critical protocol indication for p2p connection.
>
> On Thu, 2013-10-31 at 15:22 +0000, Undekari, Sunil Dutt wrote:
>>> That's not what the critical protocol stuff was designed for, so no.
>> I would consider the P2P connection phase (P2P+WPS+WPA) to be critical
>> and any off channel operations (scan) triggered by the host driver
>> would result in the delayed / failed P2P connection attempt.
>> I suppose there should be an indication to the host driver w.r.t p2p
>> connection attempt so that any off load operations on any other
>> interface sharing the same radio would be avoided by the driver.
>> Since there is already an existing interface through the critical
>> protocol indication, I thought of extending it to also include a P2P
>> protocol/connection. This new proto id would be an indication to the
>> drivers to allow the scan on the current interface and avoid any scans
>> on another considering the fact that a p2p connection requires a scan.
>> Do you propose an alternative (a new interface?) to achieve the same?
>
> Just do it in the supplicant - that has full control over what's going on with a given device.
>
> Trying to have the kernel manage multiple things that may or may not be exclusive and are all done in userspace is going to be a futile exercise.
>
> johannes
>
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{��*ޕ�,�{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+�����ݢj"��!�i


