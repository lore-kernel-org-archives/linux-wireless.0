Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792505611;
	b=dftecuG/oOMRQzaf75OVOWdZ70PSXdPgaNaeSKFuuHiZMOKyJTvePkHJOD5kf3t4sGVn
	 YeZkqEbDLWwZRwMDG9uLq7NcE2trNDM3i7CevSbmQ38IWQlpiqg9u3jhISB6S55xgaoas
	 RoTgdofFE3Do7ePK0S9W1RSXS6CmcKqBLH2RV+dqS4TzRf6JnEuvELTZJQj7ou3vAZJXu
	 P7NSE+HKxla/MBTbcH6wq3kQRk2bXApWedTJiJpeojsOiM5B4p5VG1sHdOnlsrkFQ00Yd
	 5S4LcjBq7H8RogfFAS2/54S8FcV7scboKDxaQRoXxuQJBZbgNYL/kwl5jTtTEfnsjSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792505611;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=2p+OjOHlHh/hYV4+lX5y6IE5sOmeOqo3jOvS9mTomqc=;
	b=KSwoHiGQvJEHLkgbJ6saUtzS5YsWlhG2CziNbMbrvNNamKanH8UfkiR0F7bSNUPK0/0C
	 Lcm837fF6NVphTyw5jYNRHg1gKZByLMxPTkRSCMM+yGZ5s+DNtx8/Jqo7TeFcHy/zTDbF
	 hDk6zMwvkziSLLJOeg8Oo0C0N/X4mC6gFztUwcdU/zfwvYZXhClUg73ZxhEBllZaCnrt6
	 2EIX3UeQ6s7F2bz2jvXb0M1aga/kZd/niWUhrdP5VK8iQs6ZovBU4n7Aa2lA/EKOJ3tZa
	 cw3yEJqYB6PGK/utM+2q+wVMnL7nO5Zo7qKLZnssE0NSe7tbgLPCx+11kMNVNXMkgZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.de;
	spf=pass smtp.mailfrom=gmx.de;
	dkim=pass header.d=gmx.de header.i=aleksei.kharlamov@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=eIikATpE;
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129D9606C21B;
	Tue, 20 Oct 2026 14:13:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 129D9606C21B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.de header.i=aleksei.kharlamov@gmx.de header.a=rsa-sha256 header.s=s31663417 header.b=eIikATpE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1792505571; x=1793110371;
	i=aleksei.kharlamov@gmx.de;
	bh=2p+OjOHlHh/hYV4+lX5y6IE5sOmeOqo3jOvS9mTomqc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=eIikATpEj4WwRdW0BlN3UzSD6J/dI+gaJLUdi/1LK4HJQGDo+jcmvw2gWYnLneIA
	 MSRwGvZRAWyjip2HAUA7X7v7OyBs1HHsZGBX9ysRINzTlZhSJcbabEE3RKS6fzddV
	 0EyyW5bJ2LXXdbm93TVmtvqnaJ7/FsC3XUkQqIN+k7oLYTs2vPIROKjKN+yMAFnm9
	 tZOVb9xb8HfvijbbPdRqAlZxwoJxg4aq6grxTTWOLNvMkC//Cdxe3fidTULxv/O38
	 92bJSuQZvKxHMA1lUsaRiDSX8zSXBUJbC8lNuQQcBiziYjohSMkcw17CIupO4rv2A
	 svm7t7o9+PH1zvp3tA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mv31c-1wSRP9203M-00tX5h; Tue, 20
 Oct 2026 16:12:51 +0200
Message-ID: <cf372cf0-f0e9-433c-bcaf-c218da07b1ab@gmx.de>
Date: Tue, 20 Oct 2026 16:12:47 +0200
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next 1/3] wifi: ath10k: set the PMF peer flag on
 WCN3990
To: "Nagashima, Shunsuke" <shunsuke@nagashi.ma>
Cc: Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
 ath10k@lists.infradead.org, linux-kernel@vger.kernel.org,
 David Heidelberg <david@ixit.cz>, Fabricio Akio <fabricioakio@gmail.com>
References: <20261016-ath10k-series-v1-send-v1-0-c847697b3558@nagashi.ma>
 <20261016-ath10k-series-v1-send-v1-1-c847697b3558@nagashi.ma>
 <a523eda4-5708-4427-a044-a61c0386e5a9@gmx.de>
 <CACB3TCJVoFbMEpbtvuO5c-udCoZgDvMBeH0RXUXp90hab3Dh2g@mail.gmail.com>
Content-Language: en-US
From: Aleksei Kharlamov <aleksei.kharlamov@gmx.de>
In-Reply-To: <CACB3TCJVoFbMEpbtvuO5c-udCoZgDvMBeH0RXUXp90hab3Dh2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:JQBzJOPgRcqPGjO3hgnbeyc3Qo2bjtWG+guDOVNXwfXAu9j7Jji
 HpFLD2aSM09GsstKf8w9FBgyTwnoCFfxE0jQdFOPCx/Uxza1qK51PODrPELzsgdR50PJHU1
 axQYJC3VUZlevWYuSXhQ3HKnevktkAj1xR9UuJU94gXWb2z9SRwzE1iGb6eCzoyk84jm6V6
 eDvbF9Sa75d2ln3E/qG6A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Rpw0kjYosOI=;aalfzVDKHjA5cx+GpS4nG0q9cuc
 QGP3COrB33Un0UbK6LZ0JM2UOuI2mpIQmB+B+l4BsT5pfJWisT+8WVdFsMNkccdNhJKWS1Niu
 1jlZDMKSyAB6f7TaM+1bULDjXOKytrzcMePMtK37AQ9R1TSOZPWEfuo2zR9QvDVldNy2CuWs5
 mtIYc7V3JxUgZGO91FKRSAhKRCd0PtEDPcHhesomddK9xLH5Wls9+aVDfUIKwdQkoZzKYFDJw
 pQFDpy1xGcoDMevhPPwZmIeWG6zaCDIg+nplgBYDyswxi+v6fPdmrY3GDccYpuyYTXPUFs8LM
 GEBJuoPw6ZvVLxGOsFOx9XqP49aDtG2ukaV2bGj6zWAkV+Tj3uULWxuTgRnZ/UrNZiD8sbjPa
 hnLNKjQiOKVD936/55l1tEGgqXS3jIpYkHOVftjQ1pNP5k9dCk0GTk2q80qyChCLZfXAPzgTZ
 uSldD/otuDBm75JZcXu7paIq8pRi6iAOzL4OVvlP+HeIiYnHAJgN+rzn3jGb05R7r+aAXPsu+
 tSfJAL4KguPh/DQ5AV7RWcr1Ob5O3mJTk2ads/anzRSNC5gqq8wrJm35bd0lBw3VEmTBy7eMO
 Eg43tBs+abf6o+f6ZuCrr1t/YJgVz4A8RpqbY3ICqt9HXmSfquq2i1amLqr+kN9oXlW07QShK
 xb+vldtUal31Q2nIr5DGy1V2DxqNNzubHZieLX+kzRkQMPEIlRtns7xOcQE0ZWpZaFQ0rSDyi
 qLj57EQIN/gg0I1ACt4P5NnWAhZGTyKxsfhW/HAPMEohD+KYzhwbzebs3T9ffHDyXdnRNu0L+
 wZwvWuaVQTeIZgpGceYdwVhvXSRujcoNpr2DB6DLRVLgyqg/rkEcqBVNL0k/Rk7ONkS9umnh3
 Pl1sQmPlJ2HDS9EipfMRxrBZZ6UsmKodi1KqkRzJRuVXZ6eBlKYUx8mOjt6cBexSLNS2p8LPB
 sxTPo99S0MsN06vSs0TK8PGUELo526ruUc/78gCPFpk95owdJEG8LE/bSOiiI/QyQma7rCssR
 Uv+DoU0a7Chf1K2mIiEWVyWuhvHtRjtAIcpYzGVzwN+YAbWDd5h6T6tcgLepDkpUpXaYriVLL
 xHPfrcQ5xJ5S7eim3L9Ap8JyaSAYEYLQPQh37hcc0xTT9S5SU4JINjVVlTws4Rf3eptAS6m2p
 V1l96YPnkm7wTlFJCwtqnZBKJzLupBxMMstm+F3tZGOCLP85mQ/iKVTl7P/KEnx97EN+Y5pF1
 xvMF0So0S/4W36Qzjmsm0eTkav+VZJmc5TZ0R6yAOPu06bbr7nMbNkheN32s5zn1QBdl+T5vF
 coUi1+uis4BvTN77AL0tCQOlbaaN8LN9fu2Z95sGJoZlc7DnSuUNuOBlgD7295zxI6LXclXxJ
 CpjlyNggvOUABoPR2ZcUde3jyzUztjk0zXlvN5HrAcNLC0JGBtDwqM7f7Tg/blXaChcu0TaLT
 ANxtBZYyhFg0NDt5zO+gKQVxDyzt+kgUG8xofrFj0/ibZxcPN0SjJta9vPFyTvyfCkcirit61
 O7/46VoEduHZ5AzI4w5FYtkdC4Cl41g0qRBX1YgphCKjQx45GIQxDh8FjweAcZK80lHxjHhir
 /ZrHlASdQFkNatVMeQ5eZaCdeD5Yj+hCaD/8jOO4tmEJxlqeE63beMe1vWFEAWPho8ptw7iGa
 iXCcVAdhV4OuedFO9/dLKvl9s+i5UNs5ZK80SJDviScQa5QccGlkXMIQNCPoRhnMK3GGFpcCV
 00Mt+DxSzItO3+OOl26RxldiZvbWkLxcQCzlydo2ysKmWehwz459LtRyFX4Jwx3kyF2Xm6XwP
 51UEQtHLMExgfldHTr2DQZF4YpJgQ/tK5msFS+Y/xLkOafZ3uXal+0q5K7LaVdlrPnStkoEce
 rLa2OW+pwYtFd+6rD+54N2kek8iOOY0fl7bXCHWwm9Lk64Pr1c2/hmqLHFiMjFeU4VvDoas9P
 +vJpPeNt5cPMXGllvtWmZUvVD2Ry5Aslv287/GwwTIhO5lq/9g/+LelSormwvZ+83fjv8f3IK
 PloP0/xylQvjTsDVp5SsmxQpsuIq98fRFUSxEZfm3KjXPT3S9RkZnHlI8EHzeQ8zJb9pd5rRt
 d+uh3QkVlvihc+nfjW8WHNHIkr35N/mSA/9ah3JuyQW4+SOdbe2Rkz5C6xro5Tn1Y0n0nc2uP
 ABkhs8XrknDWVdHYRil+QmdOhk+6HTkwmfGcJO+HtMSI3Q1y4QpJtd9VLckPFXuo1OTk7B1Ff
 PLSObaiOklOEIX6z6X//WZDPLmCeXzx5cYrBkyhm2c4Ke26gUpkFjGEZOKINsmncB/KlklCK5
 pm/CnkhS8r56bWwg0zJJxoJjAD7E9zcGYeWzzcrzDtSlYL2118rNMv25zS6qgy9nRGeIsSsHE
 ub1s/69cgY6kSpDG5LZ+geOYok3/JJD9AZQAKbKWAxwwCd95HyH8pNy+U5qUMdLMvM+aRqejO
 GZS74ugmfeMT+rwgwtFGtFltbP8wzQkeRENb/iMLCod6USVurEGf9h3BK9NEHZZVa57P8rPnL
 G9cWvbuKNOTEix7bjXknE8QdrQr+CGuHJfRwcwweKjwTc0I2spBxs+PeKpAH8wZHNKsIdXOej
 16H9fMhIvyV1hugRpWIhtjnEsEdlhtHZ2srdKY2O8HSvbWKdLG251qsg9yu/omQEtW4VLIl9T
 c2Lkx9spj0TcAllH6yIX0mv7eGyCJt0W899q+WSP99AWFCaDNX8ZVhQnjae/AHxgC91CdjXuZ
 WhKBRbfXSTg45LUSZDprC7A43mRGauXIiH2l5ELeKoYn/fTDNgxhYYyo7akVLqLlPAA2BwMch
 zO40t4Nhap0n4hT3cTqqrTXxw42iMcUuuY2HVIoZfh2Md1w6g75nE/bqwqikufY7smC10/g0h
 JH5azZuSWg+4geUWvVMMXcGdJkv+IvAm0v+OptwPdam6lcV8iF7DlX8FqaAgUjBAPbRe0BpFf
 fkP19OLAFvba96QLy1pEywXuBlK8wHKoeLJQpDugghek62ufhvqylOMD/PMdJnDTd9bOkDpgK
 3n1jEweLfYA/Aw4KaPcwNATQtVmMFFV3xGI0XcX169JQa2mcDq03GvPTtPR406fAESI0ZpSe2
 iVNk1IQVNEmi4scniIdBEdTjU0Jgtq7/MUaqlW7V3I0Lmug9ZPdAmYaQdtkMJcL8DqM4FAffo
 5KA9wyjm188Ivmv6E8opCwCMLEcL7jhJ3xe4A1LstoxZx1PtIXFDRupa9FLBF8T8b3lggvU9k
 yYz1nYktIJ7Dkl3a95wOVT1vswIFuugKv0grzeSoC1F6iriBsM0qcKP3sss3/4tgw+zTaWEXW
 ulm+1yWgoljgM/ViTWGTXEZtr9meMJJycwF30e09OGTupFGA1vy6Tn+ZGzxXFM65DkE8Mrjx2
 qQ/xOGDWe0N3jr+6NwtkSHbCoVHCL5IRxpEzC8KbS5kRsPM3TuNQwxK9lzcVViqO1D9EUqKCx
 QTmroQUt4w5op5qV9468JipBbfeGzTA5SR2OciaR4YlCz9Qea5suzYxuTyj6GXozs5wl1aGkx
 aRLxxKG5wkKBmqSVOimmmW1ej3kS7M4vGtOAAX65207hqnstGTgBS6VM1gMlwyXzz27m5MMO7
 hUCQL6F2hBSUlHZvGr9VejZ1ikZaxkkvY16uIWg+AVGDMiRLV8JUDoCrfJ2T0BqY3fdT+MRy0
 s/hfOBcUUiRkUyKhV810n2cRuEAIG6MyZ/H7/URFJf/kK1vPMNYyKy+b5qONPTDvB17bbbdjm
 a1gpoYaG5XaSFodC3ia6pYmUuflqsM4QL75NuAjhEsaqKx5uEh5TqzAEas7GCoqkKkBECkc+9
 BAV60k5B6zq434OKsDK+CMu58oxPTGHRwzeGFELlbURDZAtjPeidJESFpgtvV1+C+3DkfhVIE
 0sr56oEYJDMXyBnus+I7Caxdm6mGpUKpthcvw3bYYo7D7zBYXC4zI+l9DrBf/fr5PFQESXJ8B
 zxSqBrIuvBAun1Taj7ApBqfWhqnyxYtfTEOWMAyEw3qKaG3d1EnHw++NmhqA+kWtG90WpXVnh
 WtuRBpN8V96oGM79S/ah1D+VkT7/HhNBBaYEMhMncmpNq4XMswiFCWuMGtYJOCDuixZnszn0n
 X7LXBua0fU4YU3yogxY7i7SzKfImr8Ptk5QLnaGQgShwiEDhmYDinsTb/7byOoNUkuXtxgG1L
 8nBS931u7/MQubOgiYYBsxfPdbVme6npsGZ0XZW9ToS+02f3pMfXkY5mI31AhYMn6mXIGFM74
 yBicWHtsFo+q24cQFKDu8rk44h2iEDjaH/QAgvRRINqq1CPLgEPp7IEpvv77bxJwvyw+hXPeh
 asTkpDloLC+/uPrXA0whbd5pDiIE8Mm6QmOQEKpGj3UXYadwS6PZfp75pdLcITUccTeVV8DC7
 nxwauqFv8cyE9DYnw7gwSBDSXkOv+RMkhqSCohuFk9+JiAuWYTeYHewKi7yHZXC3ELEJGZ6N7
 rs6pSoe71BNTQKu+FFT3LQnS3U0sxGzOUd3FXco2v4tEJP5L/eLVSBXmXdc+SZJg06pMQ0Jsv
 ByKyYYM5MY/3NO1N8PDHvnMCqIwJejd7+iCSQjDLeqCcUcXQMsSsfwqMU3gesY9gosdxqOuRW
 m5hnpz0HYhlL94ovqkthuIXzLECgqVRRH9JzC0e0sYq5daxBTqKVGI0I9eTrD42kpaD9pEgWO
 o1tnUwinYxDWPHSMtIpcTB6RgxIXfJMYulqgR7RUtglDLoeDE8zvJp8AVhRNjqbKhZ9CjJypF
 zAGlcgzNT6TxQdvXzDd0u02dR6RAtLEL6OP21G3XWuDaxu/7jrwFZpUDaQgoPpDQHOVDPnJTw
 hYqI/hy8GeHXybim/MC+KGJH+gKTjS53QAO8dAF2X4pEZ7eemFf7JNx4TqlwHvyPXo/3qpc38
 Ltb9h+lOdA2Q0sSv0CiREe+o0DwU5XsQmf3aglapav6/+sS75ym8aMFthFUGWe1ZERw0hXErw
 pmDq2+A1k4oX99wE8XddZvaj3HyDsW2Yh4xVUpmvqE/A+/q0Ws+O2PDAXCegEM/5O4i1sNh/+
 O+DQ6Dm45BwtVVi+izoquKoYK+7ZZbawVrNh9L8Q6Dw8qYZHsCkMWceoIn2pu4sXq7f00UKf9
 U3DrFt6tiRJPYfoM1gz4wicCfUEurFlrKv9YHeYFqb3BAEfRMYdCNC3uF6TsvFB32xY2lG87b
 +HHe76I8F5uMnbEYZUgethZgEsLOiiQtcsrr+0H4iVde4llO5qVxzhHet7LLeWnJdCrrFU9xs
 ybL30umvDzGMnrS3Z2jf8rQwN9MaR7N7pChfTMy92T+duiS1tsOR5ll2LZRq6TCEGxfLtccmQ
 LLsjgKx8SU77wDwPphDTtbsdVjCD/WXfnTikwdH0Fag9kUdjJHdRvIvN5Rl83gouu3fZmRWf+
 3teuCKAl+57jyU/Ckw9hezzBh2kJb2TqJsYwFCpjW8zxUEvd9gEISl0DCiyyeXcQr9aye0k51
 AToKWAEuDlzkyiSOtxO+ZDyjyTdJlT0uy5LPfk3MJ/dDelkIFYrLDtILS7vJcwDrtDgBRMUmg
 /Torx65LEhWpKKWaHTvFnNYqSQnlpuVmer8dAX0Lup2GinEhBL1kqgL8m2WEfMe/n7+Y+jFqJ
 49ZhEFM4m71+RxXAOTuog1ULH4886YbklRv90GQwDxzwarnceDE59CABXY0OgBm83GEYuh6nH
 SJnsAMoCPT4f8CZwQfoUoRnQcmMd5CLzoLrHC6O29xkSnf0lDcBCXDpIcS83QmmOm1Lmwt0P/
 UZGk3KUG4vc5LVSWHj1juhhlgg9MfwStAxuejMeKky6y0L2ceGm24AsWl7myrmm07c4vWDUIK
 rP1A7D5ail/7MBNwx4PXPqnZ9Y1Oi2K1jlmQz23qY0Peg+pNVRjFCCemH6L0L0Kn6bJ+lOwUh
 fJ07HyfdvhikAy/2L64sd0VB7W+pPTypK7W6R7UTMv7FNOYndveGC7gdYwKfXzp/hWhs2sYpg
 vCyvvEqt54s1WOljszm3ZTkK1BXuDY13wTCoQtfps37nsohJOy2R4ahvaJzDREX5MDTFzEzWO
 06OTTUkYA102dAFMkIMiMUu+S5ozoFq4qooyPYArkWlmKJ6IyhHXvv2TjQzxmNbqCgQhw2aDj
 f6Q/V5XM2MCaIoq8EPhiuGRpOtynDEfssg2mDqa3bebiCekNO5Xrs91Oh6sciTvyCrSATf9tX
 4qoE+/4iepT8onX7zpl/q0qepNCExDxtz+N+RvIxta5P0bL6HQwVO5i6uWZ2GBEo9b02Z6Wz1
 m7Sz3UReUMB3eszo3+aYQeIJZYTxRk9oV06BHJkeg9+BuclOntExhj29/4pRuJLVFeuzBQPnm
 QQWGPNpI0D1nDd5SKUhTRmvvYpbLBaWLHrEcLhj6yir0ZX3DcbSqS76frCAhZ6iaDgyO4tngs
 L0XEskLcW+uOXK7xldaqW6O8gR9vs5dPTbrJ4GlXqQGx+ihSEUjx0YEKCNP27MH78JkCR7uWO
 cjkg9Vj10jxyaZaqvZlIJhUBzLEajlYTFS4Ms8=

Hi,

On 10/20/26 04:47, Nagashima, Shunsuke wrote:
> If you have time, could you try this patch itself (instead of your own
> version) on the Fairphone 4 and reply with a Tested-by if it works?
> WCN3988 uses the same WCN3990 entry in ath10k_hw_params_list, so the
> patch should apply to your device as it is. Station mode only is fine.

I can confirm your patch works too (same setup as my last message).
