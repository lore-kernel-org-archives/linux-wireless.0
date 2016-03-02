Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33299 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbcCBMwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 07:52:41 -0500
Received: by mail-lf0-f48.google.com with SMTP id v124so41129776lff.0
        for <linux-wireless@vger.kernel.org>; Wed, 02 Mar 2016 04:52:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56D6C3C4.4000702@student.tuwien.ac.at>
References: <56D6C3C4.4000702@student.tuwien.ac.at>
Date: Wed, 2 Mar 2016 14:52:39 +0200
Message-ID: <CANUX_P3kW2gKGVqRfZJB+PTEZJ2K8J=1UnqTb0-G92f_VRw0bw@mail.gmail.com> (sfid-20160302_135251_806309_77D592B4)
Subject: Re: iwlwifi support of 802.11k RRM (Radio Resource Mangament)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Stefan Feirer <e0926020@student.tuwien.ac.at>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 2, 2016 at 12:43 PM, Stefan Feirer
<e0926020@student.tuwien.ac.at> wrote:
>
> Hello,
>
> I'm trying to make different wifi roaming tests with the 802.11 amandments 802.11k and 802.11r.
> I use the intel wifi chipset Intel Corporation Centrino Ultimate-N 6300 and two Aerohive Access Points AP141 (with both 802.11k and 802.11r enabled).
> With using wpa_supplicant (Version 2.5) and wpa_cli (Version 2.5) I was able to connect and roam between the APs by entering the command "roam <mac>" and actually an 802.11r roam was performed. Therefore the nl80211 and iwlwifi driver was used.
> So fast roaming seems to work properly, but I faced troubles with Radio Resource Management (802.11k)
>
> Transmitting the command "neighbor_rep_request" in wpa_cli failed. I checked to log files and found the following lines:
>
> wlan0: Control interface command 'NEIGHBOR_REP_REQUEST'
> RRM: No RRM in current connection.
>
> and
>
> RRM: Determining whether RRM can be used - device support: 0x0
> RRM: Insufficient RRM support in driver - do not use RRM
>
> Now my question would be how to enable RRM, maybe using the iw-command?
> I could not find any documenation or examples according to RRM.
> The tests were performed with Ubuntu and Linux Kernel 3.13.0-79.
>

Look at  https://patchwork.kernel.org/patch/8421041/
If the suggestion of Johannes is the direction taken (which happens
quite often in mac8021..) then you'll get it.

> I hope there is someone who can help me!
> Thanks, Stefan Feirer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
