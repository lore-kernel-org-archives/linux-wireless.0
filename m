Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:53977 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab0KUKr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Nov 2010 05:47:59 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by aurora.create-net.org (Postfix) with ESMTP id 943D238363
	for <linux-wireless@vger.kernel.org>; Sun, 21 Nov 2010 11:47:57 +0100 (CET)
Received: from aurora.create-net.org ([127.0.0.1])
	by localhost (aurora.create-net.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zNOeCXRJ+cnL for <linux-wireless@vger.kernel.org>;
	Sun, 21 Nov 2010 11:47:56 +0100 (CET)
Received: from [192.168.1.220] (unknown [95.237.107.36])
	by aurora.create-net.org (Postfix) with ESMTPSA id 5D03F38326
	for <linux-wireless@vger.kernel.org>; Sun, 21 Nov 2010 11:47:56 +0100 (CET)
Message-ID: <4CE8F8D9.1020201@create-net.org>
Date: Sun, 21 Nov 2010 11:47:53 +0100
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Use case for the radiotap rate patch
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the following thread Pavel was sacking for an use case for his patch to
support the radiotap rate field;

http://thread.gmane.org/gmane.linux.kernel.wireless.general/52229/focus=52265

I'm currently using the patch in a custom routing protocol for wireless mesh
networking (www.wing-project.org). The protocol uses broadcast frames sent
at rates different from the baserate in order to implement its routing 
metric
(WCETT). Without the patch I would be forced to sample each neighbor using
unicast frames making the metric implementation not scalable with the number
of nodes.

Also, which would be the way to support the multi-rate retry chain from 
user-space?
I'm currently playing with some custom RC algorithms in users space 
using the
click modular router, but I cannot take advantage of the mrr.

thanks
R.
